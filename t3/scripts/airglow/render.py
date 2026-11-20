"""Render the static Airglow scene from NASA Blue Marble surface and cloud maps.

Source textures: NASA Goddard Space Flight Center / Reto Stöckli and Robert Simmon.
https://science.nasa.gov/earth/earth-observatory/the-blue-marble-true-color-global-imagery-at-1km-resolution/

Run: uv run --no-project --with numpy --with pillow python render.py surface.png clouds.jpg airglow.webp
Supply equirectangular maps with north at the top and Greenwich in the middle.
Surface: https://assets.science.nasa.gov/content/dam/science/esd/eo/images/bmng/bmng-base/july/world.200407.3x5400x2700.jpg
Clouds: https://phys23p.sl.psu.edu/phys_anim/astro/parallax/cloud_combined_2048.jpg
"""

import argparse
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw


def smoothstep(low, high, values):
    ramp = np.clip((values - low) / (high - low), 0, 1)
    return ramp * ramp * (3 - 2 * ramp)


def gaussian(values, width):
    return np.exp(-0.5 * (values / width) ** 2)


def sample_map(texture, east, north, forward):
    height, width = texture.shape
    longitude = np.arctan2(east, forward) + np.deg2rad(-39)
    latitude = np.arcsin(np.clip(north, -1, 1))
    u = (longitude / (2 * np.pi) + 0.5) * width
    v = np.clip((0.5 - latitude / np.pi) * height, 0, height - 1)
    left, top = np.floor(u).astype(np.int32), np.floor(v).astype(np.int32)
    fx, fy = u - left, v - top
    right = (left + 1) % width
    left %= width
    bottom = np.minimum(top + 1, height - 1)
    return (
        (1 - fy) * ((1 - fx) * texture[top, left] + fx * texture[top, right])
        + fy * ((1 - fx) * texture[bottom, left] + fx * texture[bottom, right])
    )


def read_texture(path):
    with Image.open(path) as image:
        if image.width != 2 * image.height:
            raise ValueError(f"Expected a 2:1 equirectangular texture: {path}")
        return np.asarray(image.convert("L"), dtype=np.float32) / 255


def render(surface, clouds, width, framing):
    height = round(width / 1.42)
    if framing == "close":
        center_x, center_y, radius = 0.805 * width, 1.272 * height, 0.905 * height
    else:
        center_x, center_y, radius = 0.65 * width, 1.69 * height, 1.37 * height

    column = np.arange(width, dtype=np.float32)[None, :]
    cx = (column - center_x) / radius
    rng = np.random.default_rng(1665)
    picture = np.empty((height, width, 3), dtype=np.uint8)

    for start in range(0, height, 128):
        end = min(height, start + 128)
        row = np.arange(start, end, dtype=np.float32)[:, None]
        cy = (center_y - row) / radius
        radial = np.sqrt(cx * cx + cy * cy)
        edge = radius * (radial - 1)
        front = np.sqrt(np.maximum(1 - radial * radial, 0))
        alpha = 1 - smoothstep(-0.7, 0.7, edge)

        # Roll the view, then pitch toward the Atlantic cloud systems.
        east = 0.984 * cx + 0.178 * cy
        skyward = -0.178 * cx + 0.984 * cy
        north = 0.955 * skyward + 0.297 * front
        forward = 0.955 * front - 0.297 * skyward
        land = sample_map(surface, east, north, forward)
        cloud = sample_map(clouds, 0.998 * east + 0.016 * forward, north, forward)

        # The broad twilight falls off toward the message column.
        sun = 0.71 * cx + 0.62 * cy - 0.33 * front
        twilight = smoothstep(-0.42, 0.76, sun)
        readable = 0.36 + 0.64 * smoothstep(0.33, 0.93, column / width)
        grazing = 0.44 + 0.56 * np.maximum(0, 1 - front) ** 1.45
        detail = (5 + 16 * land + 72 * smoothstep(0.11, 0.96, cloud) ** 1.24)
        detail *= (0.17 + 0.83 * twilight) * readable * grazing
        ocean = gaussian(cx + 0.20, 0.48) * smoothstep(-0.45, 0.8, cy)

        rim_light = readable * (0.37 + 0.63 * smoothstep(-0.45, 0.6, sun))
        thin_rim = gaussian(edge + 1.5, 2.3) * rim_light
        violet_air = gaussian(edge - 9, radius * 0.016) * rim_light
        far_air = gaussian(edge - 22, radius * 0.038) * rim_light
        teal_air = gaussian(edge + 2, radius * 0.007) * rim_light
        sky_wash = gaussian((column / width - 0.9) + 0.35 * (row / height - 0.58), 0.34)
        sky_wash *= gaussian(row / height - 0.53, 0.46)
        grain = rng.normal(0, 0.52, (end - start, width))

        for channel, values in enumerate((
            (12, 9, 8, 3.0, 0.68, 17, 16, 29, 32),
            (13, 11, 11, 6.5, 0.89, 39, 7, 17, 65),
            (23, 20, 19, 16, 1.12, 42, 15, 39, 53),
        )):
            floor, ocean_base, wash, sea, cloud_tint, teal, spread, violet, rim = values
            sky = floor + wash * sky_wash + spread * far_air + violet * violet_air + teal * teal_air
            globe = ocean_base + sea * ocean + cloud_tint * detail + teal * teal_air + rim * thin_rim
            color = sky * (1 - alpha) + globe * alpha + grain
            picture[start:end, :, channel] = np.clip(np.rint(color), 0, 255).astype(np.uint8)

    image = Image.fromarray(picture)
    draw = ImageDraw.Draw(image)
    for _ in range(138):
        u, v = rng.random(2)
        px, py = int(width * u), int(height * v)
        if np.hypot(px - center_x, py - center_y) <= radius * 1.03:
            continue
        gain = int(rng.uniform(4, 32) * (0.45 + 0.55 * u))
        pixel = picture[py, px]
        draw.point((px, py), tuple(int(c) + gain + j for j, c in enumerate(pixel)))
    return image


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("surface", type=Path)
    parser.add_argument("clouds", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--width", type=int, default=2600)
    parser.add_argument("--framing", choices=("close", "crescent"), default="close")
    args = parser.parse_args()
    image = render(read_texture(args.surface), read_texture(args.clouds), args.width, args.framing)
    image.save(args.output, quality=96, method=6)


if __name__ == "__main__":
    main()
