# Running Locally

Godot is installed locally but may not be available as a `godot` command in the terminal.

## Open From The Godot Editor

1. Open the Godot editor.
2. Select **Import** or **Open**.
3. Choose the repository folder.
4. Open `project.godot`.
5. Press **Play**.

## Current Controls

- Arrow keys: move the player placeholder.

## Current Gameplay Test

- Move the green player placeholder into the red enemy placeholder.
- The player should briefly flash yellow.
- The console should print the player's remaining health.

## Command-Line Checks

Do not assume `godot` is available on `PATH`.

For command-line Godot checks, either:

- skip Godot execution, or
- use the full local path to `godot.exe`.
