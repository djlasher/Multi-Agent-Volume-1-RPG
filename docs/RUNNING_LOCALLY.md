# Running Locally

Godot is installed locally but may not be available as a `godot` command in the terminal.

This project currently targets Godot `4.6.3`.

## Open From The Godot Editor

1. Open the Godot editor.
2. Select **Import** or **Open**.
3. Choose the repository folder.
4. Open `project.godot`.
5. Press **Play**.

## Current Controls

- Arrow keys: move the player placeholder.

## Current Gameplay Test

- The red enemy placeholder should slowly move toward the green player placeholder.
- Press Space or left mouse click near the enemy to attack.
- The enemy should be defeated after two successful hits.
- The defeated count should update, and a new enemy should respawn after a short delay.
- Move the green player placeholder into the red enemy placeholder.
- The player should briefly flash yellow.
- The console should print the player's remaining health.
- When health reaches zero, a Game Over label should appear and movement should stop.
- Press R after Game Over to restart the scene.

## Command-Line Checks

Do not assume `godot` is available on `PATH`.

For command-line Godot checks, either:

- skip Godot execution, or
- use the full local path to `godot_console.exe`.
