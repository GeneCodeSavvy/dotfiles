# T3 Code configuration

Preferences and themes live here in the existing ~/.config Git repository.
Original paths in ~/.t3/userdata point here through symbolic links.

- settings.json, client-settings.json, desktop-settings.json and keybindings.json contain application preferences.
- themes/ holds the published theme JSON and active animated WebP.
- scripts/sharks/ holds the approved silhouettes, swim paths, renderer, and Lean proofs.

Databases, logs, browser profiles, authentication files, attachments and caches live in ~/.t3/userdata.

From this directory, rebuild Midnight Koi to a temporary WebP.

    uv run --no-project --with opencv-python-headless --with numpy --with scipy --with pillow --with imageio-ffmpeg --with svgpathtools python scripts/sharks/render_midnight_koi.py /tmp/midnight-koi.webp

The renderer reads the existing certified swim paths and produces a transparent loop with Silk Contour bodies and dense Silk Speck Drift fins. Replace themes/midnight-koi.webp with the completed file and reapply the theme through T3 Code.

Verify the crossing model from this directory.

    lean -DwarningAsError=true scripts/sharks/Crossings.lean
