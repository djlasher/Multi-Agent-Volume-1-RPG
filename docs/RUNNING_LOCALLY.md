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
- Press Space or left mouse click near the enemy to attack; attacks have a short cooldown.
- The enemy should briefly change color/scale and be nudged back when hit.
- The enemy should be defeated after two successful hits.
- The defeated count should update, and a new enemy should respawn after a short delay.
- The wave should increase after every 3 defeated enemies.
- Later waves should make newly spawned enemies slightly faster and tougher.
- Wave 1 should keep 2 enemies active, and later waves should add more enemies up to a small cap.
- A small blue XP pickup should appear where the enemy was defeated.
- Touch the XP pickup to increase the XP count.
- At 3 XP, the player should level up and choose an upgrade with 1, 2, or 3.
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

Future milestones should run both checks:

```powershell
& "C:\Users\Clay\Desktop\godot\godot_console.exe" --headless --path "D:\Github Repos\Multi Agent Volume 1 RPG" res://scenes/main.tscn --quit-after 1
& "C:\Users\Clay\Desktop\godot\godot_console.exe" --headless --path "D:\Github Repos\Multi Agent Volume 1 RPG" -s res://tests/smoke_test.gd
```
