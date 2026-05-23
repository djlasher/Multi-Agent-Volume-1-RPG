# Codex Project Instructions

Use this file as the standing implementation guide for future Codex milestones on this Godot roguelite prototype.

## Current Implemented Systems

- Godot 4.6.3 project with `scenes/main.tscn` as the main scene.
- Start, play, game-over, and restart flow.
- Player movement, health, contact damage, basic attack, and secondary radial burst attack.
- Basic red enemies and orange rusher enemies.
- Enemy respawn, wave scaling, time scaling, and rusher active caps.
- XP pickups, health pickups, pickup-radius collection, score, timer, and run summary.
- Random 3-card upgrade choices from an upgrade pool.
- Upgrades for movement, basic attack, max health, pickup radius, secondary attack, and health drop chance.
- Timed upgrades, XP upgrades, and a 60-second milestone reward event.
- Lightweight Godot smoke test at `tests/smoke_test.gd`.

## Standing Constraints

- Keep each milestone small, readable, and reviewable.
- Preserve existing gameplay systems unless the task explicitly changes them.
- Do not add bosses, new enemy types, weapons, shops, inventory, meta progression, save data, or major refactors without an explicit request.
- Use placeholder shapes and labels only unless art assets are explicitly requested.
- Leave `.vscode/` untracked unless explicitly asked to add workspace settings.
- Use the direct Godot console path for validation:
  `C:\Users\Clay\Desktop\godot\godot_console.exe`

## Standard Workflow

1. Inspect the current branch and working tree.
2. Make the smallest useful implementation for the requested milestone.
3. Update relevant docs:
   - `docs/DEVLOG.md`
   - `DEVELOPMENT_LOG.md`
   - `docs/RUNNING_LOCALLY.md` when manual test steps change.
   - `tests/smoke_test.gd` when expected resources or scene nodes change.
4. Run both validation checks:

```powershell
& "C:\Users\Clay\Desktop\godot\godot_console.exe" --headless --path "D:\Github Repos\Multi Agent Volume 1 RPG" res://scenes/main.tscn --quit-after 1
& "C:\Users\Clay\Desktop\godot\godot_console.exe" --headless --path "D:\Github Repos\Multi Agent Volume 1 RPG" -s res://tests/smoke_test.gd
```

5. Commit with a concise professional message.
6. Push to the current branch.
7. Summarize files changed, commit hash, branch, validation results, and manual test steps.

## Next Target: Version 1.0 Presentable Prototype UI Pass

Implement only:

1. Clearer start screen instructions.
2. Clearer game-over summary including upgrades selected.
3. Simple objective/status label during play.
4. Small upgrade prompt readability improvements if needed.

Do not expand gameplay systems during Version 1.0.
