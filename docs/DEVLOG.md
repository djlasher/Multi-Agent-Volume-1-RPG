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

## Game Over Restart Loop

Goal: add the smallest lose/restart loop after player health reaches zero.

Added:

- A simple Game Over label in the main scene.
- Player movement lockout after health reaches zero.
- Restart input using R to reload the current scene.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Let the enemy contact the player until health reaches zero.
- Confirm the Game Over label appears and player movement stops.
- Press R and confirm the scene restarts.

## Player Attack Placeholder

Goal: add the smallest player attack that can defeat the enemy placeholder.

Added:

- A simple attack area around the player.
- Space and left mouse click attack input.
- Enemy health and defeat output when health reaches zero.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Move near the red enemy and press Space or left mouse click.
- Confirm the enemy prints health changes and disappears after two hits.
- Confirm movement, enemy chase, contact damage, Game Over, and R restart still work.

## Enemy Respawn Placeholder

Goal: add a minimal loop where defeating the enemy increments a count and respawns one new enemy.

Added:

- Scene-level enemy defeat tracking.
- A simple defeated enemy count label.
- Delayed respawn at a fixed spawn point.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Defeat the enemy with Space or left mouse click.
- Confirm the defeated count updates.
- Confirm a new enemy appears after a short delay and keeps chasing the player.

## XP Pickup Placeholder

Goal: add the smallest XP collection loop after defeating an enemy.

Added:

- A simple blue XP pickup that spawns at the defeated enemy's position.
- Player collection by touching the pickup.
- A simple XP count label.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Defeat the enemy with Space or left mouse click.
- Touch the blue XP pickup and confirm the XP count increases.
- Confirm enemy respawn, chase, contact damage, Game Over, and R restart still work.

## Level Up Placeholder

Goal: add the smallest automatic level-up loop from XP.

Added:

- Level tracking starting at level 1.
- Level-up trigger at 3 XP.
- Automatic movement speed increase on level-up.
- Simple level and level-up labels.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Collect 3 XP pickups by defeating enemies and touching their drops.
- Confirm XP resets to 0, level increases, and level-up feedback appears.
- Confirm player movement feels slightly faster after leveling.

## Upgrade Choice Placeholder

Goal: replace the automatic level-up upgrade with a simple keyboard choice.

Added:

- A paused upgrade choice state when XP reaches 3.
- Three keyboard choices: speed, attack damage, or max health plus heal.
- Upgrade feedback using the existing label style.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Collect 3 XP pickups.
- Confirm gameplay pauses and upgrade choices appear.
- Press 1, 2, or 3 and confirm gameplay resumes with the selected upgrade.

Fix:

- Marked gameplay scene roots as pausable so player, enemy, and XP pickup behavior stop during upgrade selection.
- Made enemy respawn timers pause during upgrade selection.

## Wave Scaling Placeholder

Goal: add simple one-enemy wave scaling without changing the spawn model.

Added:

- Wave tracking starting at wave 1.
- Wave increase after every 3 defeated enemies.
- Slight speed and health increases for newly spawned enemies on later waves.
- A simple wave label.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Defeat 3 enemies and confirm the wave label changes to wave 2.
- Confirm newly spawned enemies are slightly faster and tougher.

## Multiple Enemy Placeholder

Goal: support a small number of simultaneous enemies while keeping the existing respawn loop simple.

Added:

- Enemy group tracking.
- Two active enemies on wave 1.
- Slight enemy count increase by wave, capped at 6.
- Simple fixed spawn offsets around the existing spawn point.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Confirm two enemies are active on wave 1.
- Defeat enemies and confirm replacements spawn after a short delay.
- Reach later waves and confirm more enemies can be active without changing enemy type.

## Combat Feel Placeholder

Goal: make basic combat easier to read without adding real animations or effects.

Added:

- A short player attack cooldown.
- Console feedback when the player attacks.
- Enemy hit color/scale feedback.
- Slight enemy knockback on hit.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Attack near enemies with Space or left mouse click.
- Confirm attacks do not fire every frame.
- Confirm hit enemies briefly pulse and get nudged back.
