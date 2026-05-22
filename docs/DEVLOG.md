# Development Notes

## Initial Godot Setup

Goal: create the smallest runnable Godot foundation for the roguelite prototype.

Added:

- A Godot project file that opens directly into the main scene.
- A simple arena scene for movement testing.
- A player placeholder scene using a colored rectangle and collision shape.
- A movement script using Godot's built-in directional input actions.

Next:

- Open the project in Godot and verify the player moves in the test arena.
- Add enemy placeholder behavior after the movement loop is confirmed.

## Local Playability Instructions

Goal: make the first movement prototype easy to open and test locally.

Added:

- Manual Godot editor instructions in `docs/RUNNING_LOCALLY.md`.
- A note that command-line Godot checks require the full path to `godot.exe` if Godot is not on `PATH`.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Use the arrow keys to move the player placeholder around the test arena.

## Enemy Collision Placeholder

Goal: add the smallest enemy interaction to prove player/enemy contact can be detected.

Added:

- A stationary enemy placeholder scene using only a colored rectangle and collision shape.
- Player hit feedback that briefly changes the player color and prints remaining health.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Move the green player placeholder into the red enemy placeholder.
- Confirm the player flashes yellow and health is printed in the Godot output.

## Enemy Follow Placeholder

Goal: make the existing enemy placeholder slowly move toward the player without adding advanced AI.

Added:

- Simple enemy movement that finds the `Player` node in the current scene.
- Slow direct movement toward the player's position.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Confirm the red enemy placeholder slowly moves toward the green player placeholder.
- Confirm touching the enemy still flashes the player yellow and prints health.
