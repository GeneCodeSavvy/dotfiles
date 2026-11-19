"""Embed the Midnight Koi shark animation in stock T3 Code theme CSS."""

import argparse
import base64
import json
from pathlib import Path

import numpy as np

import bake
from render_midnight_koi import ANCHORS, INK, fuller_fin

CSS_LIMIT = 100_000
ROUTE_STRIDE = 16
SWIM_STEPS = 8
FILL = "#" + bytes(INK).hex()


def number(value, places=1):
    if places == 0:
        return str(round(value))
    return f"{value:.{places}f}".rstrip("0").rstrip(".")


def coordinates(points, places=1):
    return " ".join(number(value, places) for value in np.asarray(points).flat)


def polygon(points):
    return "M" + coordinates(points) + "Z"


def contour(points):
    # Alternate control points and endpoints to round off the polygon corners.
    return f"M{coordinates(points[0])}Q{coordinates(points[1:])} {coordinates(points[0])}Z"


def animation(attribute, values, seconds, transform=None):
    if transform:
        tag = f'animateTransform attributeName="transform" type="{transform}"'
    else:
        tag = f'animate attributeName="{attribute}"'
    return f'<{tag} dur="{seconds}s" repeatCount="indefinite" values="{";".join(values)}"/>'


def vector_shark(index, design, path, heading, speed):
    fins = [fuller_fin(np.array(fin), j) for j, fin in enumerate(design["polygons"][:3])]
    body = np.array(design["polygons"][3])[:-1:3]
    if len(body) % 2:
        body = body[:-1]
    closed_path = np.vstack((path, path[0]))
    closed_heading = np.rad2deg(np.unwrap(np.r_[heading, heading[0]]))
    samples = np.arange(0, bake.N + 1, ROUTE_STRIDE)
    assert samples[-1] == bake.N
    center_error = np.column_stack([
        np.interp(np.arange(bake.N), samples, closed_path[samples, axis]) - path[:, axis]
        for axis in range(2)
    ])
    assert np.max(np.linalg.norm(center_error, axis=1)) < 2

    translation = [coordinates(p, 0) for p in closed_path[samples]]
    rotation = [number(a, 0) for a in closed_heading[samples]]
    scale = bake.FISH_SCALE[index]
    relative_speed = np.median(speed) / (bake.RL * scale)
    speed_table = [0, .2, .4, .8, 1.3, 2.]
    frequency = np.interp(relative_speed, speed_table, [.3, .55, .85, 1.45, 1.9, 2.4])
    cycles = max(1, round(frequency * bake.SECONDS))
    period = number(bake.SECONDS / cycles, 9)
    amplitude = np.interp(relative_speed, speed_table, [.10, .15, .17, .18, .19, .2]) * bake.RL / 2
    poses = [bake.mesh(0, frame / SWIM_STEPS + index * .173, amplitude, 0)[:2]
             for frame in range(SWIM_STEPS)]
    poses.append(poses[0])

    def skin(points, pose, anchor=None):
        return bake.mapped(points, *pose, anchor) + [52, 0]

    fin_elements = []
    for fin, anchor in zip(fins, ANCHORS, strict=True):
        axes = np.array([[anchor, 0], [anchor + 1, 0]])
        frames = [skin(axes, pose, anchor) for pose in poses]
        positions = [coordinates(frame[0]) for frame in frames]
        axes_x, axes_y = (np.array(frames)[:, 1] - np.array(frames)[:, 0]).T
        angles = [number(angle) for angle in np.rad2deg(np.arctan2(axes_y, axes_x))]
        fin_path = polygon(fin[:-1] - [anchor, 0])
        fin_elements.append(
            '<g>' + animation("transform", positions, period, "translate")
            + '<g>' + animation("transform", angles, period, "rotate")
            + f'<path d="{fin_path}" fill="{FILL}" opacity=".065"/>'
            + f'<path d="{fin_path}" fill="url(#specks)"/></g></g>'
        )

    ticks = np.arange(bake.N)
    centers = path + center_error
    rotations = np.deg2rad(np.interp(ticks, samples, closed_heading[samples]))
    swim = ticks * cycles * SWIM_STEPS / bake.N
    frame = np.floor(swim).astype(int) % SWIM_STEPS
    mix = (swim % 1)[:, None, None]
    for vertices, anchor in zip([body, *fins], [None, *ANCHORS], strict=True):
        local = np.array([skin(vertices, pose, anchor) for pose in poses])
        local = (1 - mix) * local[frame] + mix * local[frame + 1]
        screen = centers[:, None, :] + scale * bake.rotate(local, rotations[:, None])
        assert screen.min() > 2 and np.min(bake.DIMS - screen) > 2

    body_frames = [contour(skin(body, pose)) for pose in poses]
    body_id = f"body{index}"
    outlines = ''.join(
        f'<use href="#{body_id}" transform="scale({x} {y})"/>'
        for x, y in [(.84, .77), (.71, .60), (.58, .43), (.45, .26)]
    )
    return (
        '<g>' + animation("transform", translation, bake.SECONDS, "translate")
        + '<g>' + animation("transform", rotation, bake.SECONDS, "rotate")
        + f'<g transform="scale({scale})">' + ''.join(fin_elements)
        + f'<g fill="none" stroke="{FILL}" stroke-width=".85" opacity=".40" stroke-linejoin="round">'
        + f'<path id="{body_id}" d="{body_frames[0]}">'
        + animation("d", body_frames, period) + '</path>' + outlines + '</g></g></g></g>'
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("theme", type=Path, help="Input copy of the Midnight Koi theme JSON")
    parser.add_argument("output", type=Path, help="Destination theme JSON")
    args = parser.parse_args()

    designs = json.loads((bake.HERE / "approved-silhouettes.json").read_text())
    paths = np.load(bake.HERE / "crossing-paths.npy")
    valid, _, headings, _, speeds = bake.certify(paths)
    assert valid
    rng = np.random.default_rng(124)
    specks = ''.join(
        f'<circle cx="{number(x)}" cy="{number(y)}" r="{number(r, 2)}" opacity="{number(alpha, 2)}"/>'
        for (x, y), r, alpha in zip(
            rng.uniform(0, 12, (90, 2)), rng.uniform(.19, .46, 90), rng.uniform(.22, .5, 90),
            strict=True,
        )
    )
    svg = (
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1160 710">'
        f'<defs><pattern id="specks" patternUnits="userSpaceOnUse" width="12" height="12" fill="{FILL}">'
        + specks + '</pattern></defs>'
        + ''.join(vector_shark(i, *data) for i, data in enumerate(zip(designs, paths, headings, speeds, strict=True)))
        + '</svg>'
    )
    data_url = "data:image/svg+xml;base64," + base64.b64encode(svg.encode()).decode()
    theme = json.loads(args.theme.read_text())
    theme["name"] = "Midnight Koi Vector"
    assert "var(--theme-background-image)" in theme["css"]
    theme["css"] = (
        f':root{{--midnight-koi-sharks:url("{data_url}")}}\n'
        + theme["css"].replace("--theme-background-image", "--midnight-koi-sharks")
    )
    if len(theme["css"]) > CSS_LIMIT:
        raise ValueError(f"Generated CSS exceeds the {CSS_LIMIT:,}-character theme limit")
    args.output.write_text(json.dumps(theme, indent=2, ensure_ascii=False) + "\n")
    print(f"{len(svg):,} SVG bytes, {len(theme['css']):,} CSS characters")


if __name__ == "__main__":
    main()
