# Development Log

## 2026-05-22 - Initial Godot Setup

Goal: establish the smallest runnable Godot foundation for the multi-agent roguelite prototype.

What exists now:

- A Godot 4 project configured to launch `scenes/main.tscn`.
- A minimal test arena with a player instance and camera.
- A placeholder `CharacterBody2D` player scene.
- A simple movement script using Godot's built-in directional input actions.
- Basic docs in `docs/DEVLOG.md` and local run instructions in `docs/RUNNING_LOCALLY.md`.

Changed today:

- Created branch `initial-godot-setup`.
- Added the initial Godot project structure.
- Added movement-only player scaffolding with no enemies, combat, upgrades, or agent systems yet.
- Added Godot-focused ignore rules.
- Documented how to open the project manually from the Godot editor when `godot` is not on `PATH`.

Suggested next milestones:

1. Open the project in Godot and confirm the player moves in the arena.
2. Add one enemy placeholder that follows or approaches the player.
3. Add basic health and damage so the first combat loop can be tested.
