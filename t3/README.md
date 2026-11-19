# T3 Code configuration

Preferences and themes live here in the existing ~/.config Git repository.
Original paths in ~/.t3/userdata point here through symbolic links.

- settings.json, client-settings.json, desktop-settings.json and keybindings.json contain application preferences.
- themes/ holds the published themes.
- scripts/sharks/ holds the Midnight Koi theme source, silhouette data, swim paths, SVG generator, and Lean proofs.

Databases, logs, browser profiles, authentication files, attachments and caches live in ~/.t3/userdata.

From this directory, rebuild Midnight Koi Vector as a temporary theme file.

    uv run --no-project --with opencv-python-headless --with numpy --with scipy --with pillow --with imageio-ffmpeg --with svgpathtools python scripts/sharks/render_vector_theme.py /tmp/midnight-koi-vector.json

The SVG uses sampled routes and a repeating tail stroke for each shark. Move the finished JSON to themes/midnight-koi-vector.json and run `t3 theme set midnight-koi-vector` to apply it.

Verify the crossing model from this directory.

    lean -DwarningAsError=true scripts/sharks/Crossings.lean
