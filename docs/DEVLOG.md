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

## Smoke Test Placeholder

Goal: add a lightweight headless validation script for future milestones.

Added:

- A Godot smoke test script at `tests/smoke_test.gd`.
- Resource checks for core scenes and scripts.
- Main scene instantiation checks.
- Expected node/script checks for the current prototype.

Current test:

- Run the headless scene launch validation.
- Run the smoke test script.
- Confirm both commands exit successfully.

## Run Timer And Summary Placeholder

Goal: add a minimal run timer and Game Over summary.

Added:

- Elapsed time tracking during active gameplay.
- A simple time label.
- Timer pause during upgrade choice.
- Run summary on Game Over with time, enemies defeated, level reached, and wave reached.

Current test:

- Open `project.godot` from the Godot editor and press Play.
- Confirm the timer counts up during gameplay.
- Trigger a level-up choice and confirm the timer pauses.
- Reach Game Over and confirm the summary appears.

## Version 0.1 Round Loop

Goal: turn the prototype into a repeatable mini roguelite round loop without refactoring the project.

Added:

- Start/play/game-over state flow.
- Start screen that waits for Enter or Space.
- Score display based on enemies defeated.
- Time-based enemy scaling tiers at 30 and 60 seconds.
- Timed upgrade choice prompts using the existing upgrade UI.

Current test:

- Start the run from the start screen.
- Confirm the timer and score update only during active play.
- Survive long enough to see the timed upgrade choice.
- Confirm Game Over still shows the summary and R restarts the scene.

## Version 0.2 Upgrade Choice Cards

Goal: replace the fixed upgrade prompt with a small roguelite-style choice card loop.

Added:

- Randomly dealt sets of 3 upgrade choices from a 5-upgrade pool.
- Real effects for move speed, attack speed, damage, max health, and pickup radius upgrades.
- A simple upgrade count/latest-upgrade label.
- Pickup radius collection so XP can be collected from slightly farther away after upgrading.

Current test:

- Start a run and collect 3 XP, or survive until the timed upgrade interval.
- Confirm gameplay pauses and 3 random upgrade cards appear.
- Press 1, 2, or 3 and confirm gameplay resumes.
- Confirm the upgrade count/latest label updates and the selected upgrade affects play.

## Version 0.3 Enemy Variety

Goal: add one small enemy variant without changing the core round loop.

Added:

- A rusher enemy scene that reuses the existing enemy script.
- Faster, lower-health rusher behavior.
- Orange color and smaller scale so rushers read differently from basic red enemies.
- Time-gated rusher spawning after the run has been active for about 35 seconds.

Current test:

- Start a run and survive past 35 seconds.
- Defeat enemies until an orange rusher appears.
- Confirm rushers move faster, take fewer hits than similarly scaled basic enemies, and still grant score/XP on defeat.
- Confirm Game Over, restart, upgrades, wave scaling, and basic enemy spawns still work.

## Version 0.4 Balance And Debug Testability

Goal: make early manual testing easier without changing the core gameplay loop.

Added:

- Exported tuning for starting player health and existing enemy/spawn values.
- Gentler default opening values: 5 player health, 1 starting enemy, slower respawn, smaller enemy cap, and earlier rusher unlock.
- Opt-in debug time skip for rusher testing with F6 when `debug_enable_rusher_time_skip` is enabled on the `Main` node.

Current test:

- Start a normal run and confirm the opening is less crowded but still dangerous.
- Survive to about 32 seconds and confirm rushers can begin appearing.
- In the editor, enable `debug_enable_rusher_time_skip` on `Main`, start a run, press F6, and confirm the timer jumps near rusher unlock.
- Confirm F6 does nothing in normal play when the debug flag is disabled.

## Version 0.5 Rusher Spawn Smoothing

Goal: keep rusher enemies exciting without letting several spawn immediately after unlock.

Added:

- Active rusher cap support in the existing spawn selection.
- A cap of 1 active rusher from unlock until 60 seconds.
- A cap of 2 active rushers after 60 seconds.

Current test:

- Start a run and survive until rushers unlock around 32 seconds.
- Confirm no more than 1 orange rusher is active before 60 seconds.
- Survive past 60 seconds and confirm up to 2 rushers can be active.
- Confirm basic enemy spawning, XP, score, upgrades, Game Over, restart, wave scaling, and debug time skip still work.

## Version 0.6 Secondary Attack Option

Goal: add one alternate player attack without creating a full weapon system.

Added:

- E-key secondary radial burst attack.
- Exported secondary attack damage, cooldown, and radius on the player.
- Longer secondary cooldown than the basic attack.
- Simple purple placeholder flash and console feedback when the burst is used.

Current test:

- Start a run and move near one or more enemies.
- Press Space or left mouse click and confirm the original basic attack still works.
- Press E and confirm nearby enemies take burst damage and the purple feedback appears.
- Confirm E cannot be spammed because of its longer cooldown.

## Version 0.7 Health Pickup And Recovery

Goal: add a small survival recovery mechanic without adding meta progression or inventory.

Added:

- Chance-based green health pickup drops from defeated enemies.
- Health pickups restore 1 player health, capped at max health.
- Health pickup collection uses the same pickup-radius behavior as XP pickups.
- Console feedback shows healing results during manual testing.

Current test:

- Take damage from an enemy, then defeat enemies until a green health pickup drops.
- Touch or move near the green pickup and confirm health restores by 1 without exceeding max health.
- Confirm blue XP pickups, score, upgrades, Game Over, restart, waves, and enemy spawning still work.

## Version 0.8 Expanded Upgrade Pool

Goal: make level-up choices more interesting by adding secondary attack and survival upgrades.

Added:

- Secondary Damage Up for stronger E-key bursts.
- Secondary Cooldown Down with a minimum cooldown.
- Secondary Radius Up that updates burst collision and visual size.
- Health Drop Chance Up with a capped health pickup drop chance.

Current test:

- Trigger several level-up choices through XP or timed upgrades.
- Confirm the new upgrade cards can appear alongside existing upgrades.
- Select each new upgrade when available and confirm it changes secondary burst damage, cooldown, radius, or health pickup drop chance.
- Confirm existing upgrades, XP, health pickups, enemies, Game Over, restart, and score still work.

## Version 0.9 Milestone Reward Event

Goal: make longer survival feel more meaningful with one lightweight timed reward.

Added:

- A once-per-run 60-second survival milestone.
- Bonus score when the milestone is reached.
- An immediate upgrade choice using the existing upgrade-card flow.
- Exported milestone time and score bonus tuning.

Current test:

- Start a run and survive to 60 seconds.
- Confirm the milestone message appears, score increases, and one upgrade choice opens.
- Pick an upgrade and confirm gameplay resumes.
- Confirm normal timed upgrades, XP upgrades, score, enemies, pickups, Game Over, and restart still work.

## Version 1.0 Presentable Prototype UI Pass

Goal: make the current prototype easier to understand and present without adding gameplay systems.

Added:

- Clearer start screen instructions for movement, attacks, survival, and upgrades.
- A simple objective/status label during play and upgrade pauses.
- Game-over summary text that includes selected upgrades.
- Slightly more readable upgrade choice spacing.
- Reusable Codex project instructions in `docs/next-implementation-plan.md`.

Current test:

- Start the project and confirm the start screen explains the controls and objective.
- Start a run and confirm the status label updates during play.
- Trigger an upgrade and confirm the status label and upgrade prompt are readable.
- End a run and confirm the summary includes selected upgrades.
