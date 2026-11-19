"""Bake the active Midnight Koi background as a transparent animated WebP."""
import argparse
import json
import subprocess
from contextlib import ExitStack
from pathlib import Path

import cv2
import imageio_ffmpeg
import numpy as np
from scipy.ndimage import gaussian_filter1d

HERE = Path(__file__).resolve().parent
import bake

WIDTH, HEIGHT = 1160, 710
OUTPUT_SIZE = (744, 456)
INK = (201, 194, 225)
ANCHORS = (1, 1, -57)
STIPPLE_SEED = int("bb36822b24e5beef", 16)
MAX_BYTES = 16_000_000


def fuller_fin(fin, index):
    # Keep the attachment fixed and widen across the appendage's sweep.
    if index == 2:
        root = np.array([-53., 0.])
        return root + (fin - root) * [1.04, 1.23]
    root = (fin[0] + fin[-2]) / 2
    axis = fin[6] - root
    axis /= np.linalg.norm(axis)
    offset = fin - root
    along = np.outer(offset @ axis, axis)
    return root + 1.06 * along + 1.25 * (offset - along)


def stipple(fin, rng, spacing, tip_fade, density):
    """Seed dots in the fin's rest frame so they move with the membrane."""
    root, tip = fin[0], fin[12]
    direction = (tip - root) / np.linalg.norm(tip - root)
    length = np.linalg.norm(tip - root)
    samples, weights = [], []
    polygon = fin.astype(np.float32)
    low, high = fin.min(axis=0), fin.max(axis=0)
    for x in np.arange(low[0], high[0], spacing):
        for y in np.arange(low[1], high[1], spacing):
            p = np.array([x, y]) + rng.uniform(-.65, .65, 2)
            distance = np.dot(p - root, direction) / length
            if rng.random() > np.clip(density - tip_fade*distance, .14, .9):
                continue
            if cv2.pointPolygonTest(polygon, tuple(p), False) >= 0:
                samples.append(p)
                weights.append(rng.integers(58, 121))
    return np.asarray(samples).reshape(-1, 2), weights


def raster(points):
    return np.rint(points * 16).astype(np.int32)


def clipped_strokes(mask, polygon, contours, opacity):
    clip = np.zeros_like(mask)
    lines = np.zeros_like(mask)
    cv2.fillPoly(clip, [raster(polygon)], 255, cv2.LINE_AA, shift=4)
    for contour in contours:
        cv2.polylines(lines, [raster(contour)], True, opacity, 1, cv2.LINE_AA, shift=4)
    np.maximum(mask, np.minimum(clip, lines), out=mask)


def encoder(path):
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    return subprocess.Popen([
        ffmpeg, "-hide_banner", "-loglevel", "error", "-y",
        "-f", "rawvideo", "-pix_fmt", "rgba", "-s", f"{OUTPUT_SIZE[0]}x{OUTPUT_SIZE[1]}",
        "-r", str(bake.FPS), "-i", "pipe:0", "-an", "-c:v", "libwebp_anim",
        "-lossless", "1", "-quality", "85", "-compression_level", "6",
        "-loop", "0", str(path),
    ], stdin=subprocess.PIPE)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path, help="Destination WebP file")
    args = parser.parse_args()
    cv2.setNumThreads(2)

    designs = json.loads((HERE / "approved-silhouettes.json").read_text())
    assert len(designs) == bake.COUNT == 9
    patterns = []
    for i, design in enumerate(designs):
        polygons = design["polygons"]
        fins = [fuller_fin(np.array(p), index) for index, p in enumerate(polygons[:3])]
        dots = [
            stipple(fin, np.random.default_rng(STIPPLE_SEED + i*3 + j), 1.22, .33, .96)
            for j, fin in enumerate(fins)
        ]
        patterns.append((fins, np.array(polygons[3]), dots))

    paths = np.load(bake.HERE / "crossing-paths.npy")
    valid, _, headings, yaw, speed = bake.certify(paths)
    assert valid
    v = speed / (bake.RL*bake.FISH_SCALE[:, None])
    table = [0, .2, .4, .8, 1.3, 2.]
    freq = np.interp(v, table, [.3, .55, .85, 1.45, 1.9, 2.4])
    cycles = freq.sum(axis=1)*bake.DT
    freq += ((np.rint(cycles)-cycles)/bake.SECONDS)[:, None]
    phase = np.c_[np.zeros(bake.COUNT), np.cumsum(freq[:, :-1]*bake.DT, axis=1)]
    phase += np.arange(bake.COUNT)[:, None]*.173
    amplitude = gaussian_filter1d(np.interp(v, table, [.10,.15,.17,.18,.19,.2])*bake.RL*.5,
                                  bake.FPS*.23, axis=1, mode="wrap")
    bend = np.clip(.75*bake.RL*yaw/bake.DT/np.maximum(speed/bake.FISH_SCALE[:, None], .5*bake.RL), -.45, .45)
    bend = gaussian_filter1d(bend, bake.FPS*.17, axis=1, mode="wrap")
    frame = np.empty((OUTPUT_SIZE[1], OUTPUT_SIZE[0], 4), dtype=np.uint8)
    frame[:, :, :3] = INK
    minimum_edge = float("inf")
    output = encoder(args.output)
    with ExitStack() as stack:
        stack.callback(output.wait)
        stack.callback(output.stdin.close)
        for tick in range(bake.N):
            alpha = np.zeros((HEIGHT, WIDTH), np.uint8)
            for i, (fins, body, dots) in enumerate(patterns):
                h, scale = headings[i, tick], bake.FISH_SCALE[i]
                joints, angles, _ = bake.mesh(h, phase[i, tick], amplitude[i, tick], bend[i, tick])
                nose = paths[i, tick] + 52*scale*np.array([np.cos(h), np.sin(h)])

                def world(polygon, anchor=None):
                    return nose + scale*bake.mapped(polygon, joints, angles, anchor)

                fin_points = [world(fin, anchor) for fin, anchor in zip(fins, ANCHORS, strict=True)]
                body_points = world(body)
                points = np.concatenate([*fin_points, body_points])
                low, high = points.min(axis=0), points.max(axis=0)
                minimum_edge = min(minimum_edge, *low, *(np.array([WIDTH, HEIGHT])-high))
                assert minimum_edge > 2, minimum_edge
                x0, y0 = np.floor(low).astype(int)-2
                x1, y1 = np.ceil(high).astype(int)+3
                origin = np.array([x0, y0])
                region = np.s_[y0:y1, x0:x1]
                local = alpha[region]
                center = np.array([9., 0.])
                lines = [world(center+(body-center)*[.97-.13*k,.94-.17*k])-origin for k in range(5)]
                clipped_strokes(local, body_points-origin, lines, 124)
                for j, anchor in enumerate(ANCHORS):
                    fin_outline = fin_points[j]-origin
                    silhouette = np.zeros_like(local)
                    cv2.fillPoly(silhouette, [raster(fin_outline)], 255, cv2.LINE_AA, shift=4)
                    speckles = np.zeros_like(local)
                    points, weights = dots[j]
                    for point, weight in zip(raster(world(points, anchor)-origin), weights, strict=True):
                        cv2.circle(speckles, point, 12, int(weight), -1, cv2.LINE_AA, shift=4)
                    fin_alpha = np.maximum(speckles, (silhouette.astype(np.uint16)*19//255).astype(np.uint8))
                    np.maximum(local, np.minimum(fin_alpha, silhouette), out=local)
            resized = cv2.resize(alpha, OUTPUT_SIZE, interpolation=cv2.INTER_AREA)
            # Quantize alpha only to keep the full 40 fps loop below T3's asset limit.
            frame[:, :, 3] = ((resized.astype(np.uint16)+16)//32*32).astype(np.uint8)
            output.stdin.write(frame.tobytes())
            if tick % 400 == 0:
                print(f"Rendered {tick}/{bake.N}", flush=True)
    assert output.returncode == 0
    assert args.output.stat().st_size < MAX_BYTES, args.output.stat().st_size
    assert minimum_edge > 2, minimum_edge
    print(f"Rendered {bake.N} frames. Minimum edge clearance: {minimum_edge:.1f}px.")


if __name__ == "__main__":
    main()
