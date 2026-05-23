# Next Implementation Plan

## Goal
Turn the current 30-second chaotic prototype into a repeatable mini roguelite loop.

## Current State
- Basic game runs
- Short rounds work
- Difficulty ramps quickly
- Core chaos/fun exists

## Next Build Target: Version 0.1

### 1. Core Round Loop
Add a simple round structure:
- Start screen
- Play state
- Game over state
- Restart button
- Score display
- Survival timer

### 2. Player Progression
Add one upgrade choice every 20–30 seconds:
- +Move Speed
- +Attack Speed
- +Damage
- +Max Health
- +Pickup Radius

Only implement 3 upgrades at first.

### 3. Enemy Scaling
Enemies should scale based on time:
- 0–30 sec: slow basic enemies
- 30–60 sec: faster enemies
- 60+ sec: more spawns and/or tougher enemies

### 4. Simple Pickups
Add drops:
- XP orb
- Health pickup
- Temporary speed boost

### 5. Debug UI
Show:
- Timer
- Score
- Level
- Current upgrades
- Enemy count

## Important Constraint
Do not refactor the entire project yet. Add the smallest clean systems possible.

## Codex Task Prompt
Implement a minimal roguelite round loop using the existing prototype. Add:
1. start/play/game-over states,
2. a survival timer,
3. score,
4. restart,
5. basic enemy scaling over time,
6. one simple upgrade choice after a short interval.

Keep changes small and explain each file changed.