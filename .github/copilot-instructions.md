## Quick orientation for AI coding agents

This repo is Speech Note (dsnote) — a large C++/Qt6 desktop + Sailfish OS app that integrates many offline STT/TTS/MT engines.
Follow these concise rules to be productive quickly.

1. Big picture
   - Core library: `src/` holds the main C++ code. The primary target is assembled in `CMakeLists.txt` and creates `dsnote_lib` + the binary.
   - Engines: speech/stt and tts implementations live under `src/` with filenames like `whisper_engine.cpp/.hpp`, `ds_engine.*`, `vosk_engine.*`, `piper_engine.*`, `coqui_engine.*`, etc. Treat each engine as a plugin-style implementation inside the monolithic build.
   - Packaging: builds are primarily done with Flatpak (`flatpak/`) or plain CMake (`CMakeLists.txt`). Packaging helpers are in `arch/`, `deb/`, and `sfos/`.
   - Models/config: runtime models and downloads are defined in `config/models.json`. User copies live at `~/.local/share/net.mkiol/dsnote/models.json` (or Flatpak path under `~/.var/app/...`). Use the app's `--gen-checksums` CLI to produce checksums when adding models.

2. Build & test workflows (concrete commands)
   - Recommended (Fast, reproducible): use Flatpak manifests in `flatpak/` and the README Flatpak commands.
     - Example: `flatpak-builder --force-clean --user --install-deps-from=flathub --repo="<repo>" "/out/dir" net.mkiol.SpeechNote.yaml`
   - Direct CMake build (local dev):
     - mkdir build && cd build
     - cmake ../ -DCMAKE_BUILD_TYPE=Release -DWITH_DESKTOP=ON
     - make
   - Toggle important CMake options (see top-level `CMakeLists.txt`):
     - `-DWITH_DESKTOP=ON|OFF` main switch for desktop UI
     - `-DWITH_PY=ON|OFF` enable Python-backed features (requires pybind/py deps)
     - `-DBUILD_WHISPERCPP=ON|OFF`, `-DBUILD_WHISPERCPP_CUBLAS=ON|OFF` etc. (GPU/CUDA variants are x86_64-only)
     - Avoid enabling both `DOWNLOAD_VOSK` and `BUILD_VOSK` at the same time.
   - Tests: enable `-DWITH_TESTS=ON` then build; tests live under `tests/` but may require many deps. For quick iterations prefer unit-level C++ edits + small smoke runs.

3. Runtime & debugging
   - CLI interface lives in the built binary or the Flatpak runtime. Common examples are in `README.md` (e.g. `--action start-listening`).
   - DBus integration: DBus templates in `dbus/` and `systemd/` show service names and interfaces (e.g. `net.mkiol.Speech`, `net.mkiol.dsnote`). Use these files to understand IPC boundaries.
   - Logs: `src/logger.*` and `src/qtlogger.*` centralize logging. Use `--verbose` when running via Flatpak to get more output.

4. Project-specific conventions and patterns
   - Single repository with many vendored/optional external projects controlled via CMake `BUILD_*` flags; toggles frequently change which libraries are built vs downloaded.
   - Engines are implemented as C++ classes in `src/` following pattern `*_engine.{cpp,hpp}` and expose functionality through `tts_engine.hpp` / `stt_engine.hpp` abstractions.
   - Python integration: look for `pybind11` and `py_executor.*` / `py_tools.*` when working on Python-related features; enabling `WITH_PY` pulls in many Python-only functionality and dependencies.
   - Model metadata and download checksums live in `config/models.json` — update it when adding models and use the `--gen-checksums` runtime option to generate correct checksum values.

5. Integration points & external dependencies
   - Many heavy deps are optional and either downloaded or built during CMake: `whisper.cpp`, `Vosk`, `Coqui`, `Piper`, `RHVoice`, `ffmpeg`, `openblas`, `faster-whisper`, etc. See `CMakeLists.txt` and `cmake/*.cmake` for per-dependency logic.
   - GPU options: `BUILD_WHISPERCPP_CUBLAS`, `BUILD_WHISPERCPP_HIPBLAS`, `BUILD_WHISPERCPP_CLBLAST` control accelerated builds; these are architecture-sensitive (x86_64 vs arm64).
   - Flatpak packaging merges many binary modules into add-ons (see `flatpak/` and README). For developer builds prefer flatpak to avoid dependency hell.

6. Safe editing rules for AI agents
   - Prefer small, local changes. For behavioral changes, update unit-level code under `src/` and add a short note in commit message referencing the affected engine(s) and CMake flags.
   - Do NOT toggle large BUILD_* flags in the main CI or create changes that require rebuilding huge external deps without sign-off — note in PR description if you changed `BUILD_WHISPERCPP_*` or similar.
   - When changing model metadata, always run `--gen-checksums` locally (or instruct maintainers how to run it inside Flatpak) and update `config/models.json` with both `checksum` and `checksum_quick`.

7. Useful files to open first (examples)
   - `CMakeLists.txt` (top-level): global options and feature flags.
   - `config/models.json`: model metadata and enabled downloads.
   - `src/dsnote_app.cpp`, `src/speech_service.*`: app lifecycle and IPC boundaries.
   - `src/whisper_engine.*`, `src/piper_engine.*`, `src/coqui_engine.*`: canonical engine implementation examples.
   - `dbus/` and `systemd/`: service names, DBus interfaces and templates.

If any section is unclear or you need deeper examples (unit test patterns, typical small-change PRs, or reproducing a runtime bug), tell me which area to expand and I will iterate.
