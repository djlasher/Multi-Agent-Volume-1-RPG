extends Node2D

const ENEMY_SCENE := preload("res://scenes/enemy.tscn")
const RUSHER_ENEMY_SCENE := preload("res://scenes/rusher_enemy.tscn")
const XP_PICKUP_SCENE := preload("res://scenes/xp_pickup.tscn")
const HEALTH_PICKUP_SCENE := preload("res://scenes/health_pickup.tscn")

enum GameState { START, PLAYING, GAME_OVER }

@export var enemy_respawn_delay: float = 1.5
@export var xp_to_level: int = 3
@export var timed_upgrade_interval: float = 25.0
@export var speed_upgrade_amount: float = 25.0
@export var attack_speed_upgrade_amount: float = 0.05
@export var attack_damage_upgrade_amount: int = 1
@export var max_health_upgrade_amount: int = 1
@export var pickup_radius_upgrade_amount: float = 18.0
@export var secondary_damage_upgrade_amount: int = 1
@export var secondary_cooldown_upgrade_amount: float = 0.25
@export var secondary_radius_upgrade_amount: float = 16.0
@export var health_drop_chance_upgrade_amount: float = 0.1
@export var max_health_pickup_drop_chance: float = 0.75
@export var enemies_per_wave: int = 3
@export var base_enemy_count: int = 1
@export var max_enemy_count: int = 5
@export var rusher_enemy_unlock_time: float = 32.0
@export var rusher_enemy_spawn_chance: float = 0.45
@export var early_rusher_cap: int = 1
@export var late_rusher_cap: int = 2
@export var late_rusher_cap_time: float = 60.0
@export var starting_player_health: int = 5
@export var health_pickup_drop_chance: float = 0.25
@export var milestone_time: float = 60.0
@export var milestone_score_bonus: int = 500
@export var debug_enable_rusher_time_skip: bool = false

var enemies_defeated: int = 0
var xp: int = 0
var level: int = 1
var wave: int = 1
var choosing_upgrade: bool = false
var elapsed_time: float = 0.0
var run_over: bool = false
var score: int = 0
var game_state: GameState = GameState.START
var next_timed_upgrade_at: float = timed_upgrade_interval
var current_upgrade_choices: Array[Dictionary] = []
var selected_upgrades: Array[String] = []
var milestone_awarded: bool = false

@onready var defeated_count_label: Label = $GameUI/DefeatedCountLabel
@onready var score_label: Label = $GameUI/ScoreLabel
@onready var xp_count_label: Label = $GameUI/XPCountLabel
@onready var level_label: Label = $GameUI/LevelLabel
@onready var wave_label: Label = $GameUI/WaveLabel
@onready var time_label: Label = $GameUI/TimeLabel
@onready var upgrade_count_label: Label = $GameUI/UpgradeCountLabel
@onready var status_label: Label = $GameUI/StatusLabel
@onready var start_label: Label = $GameUI/StartLabel
@onready var level_up_label: Label = $GameUI/LevelUpLabel
@onready var upgrade_choice_label: Label = $GameUI/UpgradeChoiceLabel
@onready var run_summary_label: Label = $GameUI/RunSummaryLabel
@onready var game_over_label: Label = $GameUI/GameOverLabel
@onready var enemy_spawn_point: Node2D = $EnemySpawnPoint
@onready var player = $Player
@onready var enemy = $Enemy

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	randomize()
	_apply_starting_player_health()
	_update_defeated_count()
	_update_score()
	_update_xp_count()
	_update_level()
	_update_wave()
	_update_time()
	_update_upgrade_count()
	_update_status("Objective: Press Enter or Space to start")
	_configure_enemy(enemy)
	_fill_enemy_count()
	get_tree().paused = true
	start_label.visible = true
	level_up_label.visible = false
	upgrade_choice_label.visible = false
	run_summary_label.visible = false
	game_over_label.visible = false

func _process(delta: float) -> void:
	if game_state != GameState.PLAYING or run_over or choosing_upgrade:
		return

	elapsed_time += delta
	_update_time()
	if not milestone_awarded and elapsed_time >= milestone_time:
		_award_survival_milestone()
	elif elapsed_time >= next_timed_upgrade_at:
		_start_upgrade_choice()

func enemy_defeated(defeat_position: Vector2) -> void:
	enemies_defeated += 1
	score += 100
	var next_wave := int(enemies_defeated / enemies_per_wave) + 1
	if next_wave != wave:
		wave = next_wave
		_update_wave()
		print("Wave: %s" % wave)
	_update_defeated_count()
	_update_score()
	print("Enemies defeated: %s" % enemies_defeated)
	_spawn_xp_pickup(defeat_position)
	_try_spawn_health_pickup(defeat_position)
	_respawn_enemy_after_delay()

func collect_xp(amount: int) -> void:
	xp += amount
	if xp >= xp_to_level:
		_start_upgrade_choice()
	_update_xp_count()
	print("XP: %s" % xp)

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return

	if game_state == GameState.START:
		if event.keycode == KEY_ENTER or event.keycode == KEY_SPACE:
			_start_run()
		return

	if game_state == GameState.GAME_OVER:
		if event.keycode == KEY_R:
			get_tree().paused = false
			get_tree().reload_current_scene()
		return

	if game_state == GameState.PLAYING and not choosing_upgrade and event.keycode == KEY_F6:
		_debug_skip_near_rusher_unlock()
		return

	if not choosing_upgrade:
		return

	if event.keycode == KEY_1:
		_select_upgrade(0)
	elif event.keycode == KEY_2:
		_select_upgrade(1)
	elif event.keycode == KEY_3:
		_select_upgrade(2)

func _respawn_enemy_after_delay() -> void:
	await get_tree().create_timer(enemy_respawn_delay, false).timeout
	_fill_enemy_count()

func _fill_enemy_count() -> void:
	var target_count := _target_enemy_count()
	while get_tree().get_nodes_in_group("enemies").size() < target_count:
		_spawn_enemy()

func _spawn_enemy() -> void:
	var new_enemy := _enemy_scene_for_spawn().instantiate()
	var spawn_index := get_tree().get_nodes_in_group("enemies").size()
	new_enemy.position = _spawn_position_for_index(spawn_index)
	_configure_enemy(new_enemy)
	add_child(new_enemy)

func _enemy_scene_for_spawn() -> PackedScene:
	if _can_spawn_rusher() and randf() < rusher_enemy_spawn_chance:
		return RUSHER_ENEMY_SCENE
	return ENEMY_SCENE

func _can_spawn_rusher() -> bool:
	return elapsed_time >= rusher_enemy_unlock_time and _active_rusher_count() < _current_rusher_cap()

func _active_rusher_count() -> int:
	var count := 0
	for enemy_node in get_tree().get_nodes_in_group("enemies"):
		if enemy_node.get("enemy_variant") == "rusher":
			count += 1
	return count

func _current_rusher_cap() -> int:
	if elapsed_time >= late_rusher_cap_time:
		return late_rusher_cap
	return early_rusher_cap

func _target_enemy_count() -> int:
	return min(base_enemy_count + wave - 1, max_enemy_count)

func _spawn_position_for_index(spawn_index: int) -> Vector2:
	var offsets := [
		Vector2.ZERO,
		Vector2(-140, -90),
		Vector2(140, -90),
		Vector2(-160, 90),
		Vector2(160, 90),
		Vector2(0, -150),
	]
	return enemy_spawn_point.position + offsets[spawn_index % offsets.size()]

func _spawn_xp_pickup(spawn_position: Vector2) -> void:
	var pickup := XP_PICKUP_SCENE.instantiate()
	pickup.position = spawn_position
	add_child(pickup)

func _try_spawn_health_pickup(spawn_position: Vector2) -> void:
	if randf() > health_pickup_drop_chance:
		return

	var pickup := HEALTH_PICKUP_SCENE.instantiate()
	pickup.position = spawn_position + Vector2(18, 0)
	add_child(pickup)
	print("Health pickup dropped")

func _apply_starting_player_health() -> void:
	player.max_health = starting_player_health
	player.health = starting_player_health

func _debug_skip_near_rusher_unlock() -> void:
	if not debug_enable_rusher_time_skip:
		return

	elapsed_time = max(elapsed_time, max(0.0, rusher_enemy_unlock_time - 1.0))
	next_timed_upgrade_at = max(next_timed_upgrade_at, elapsed_time + 5.0)
	_update_time()
	print("Debug: skipped run timer near rusher unlock.")

func player_game_over() -> void:
	if run_over:
		return

	run_over = true
	game_state = GameState.GAME_OVER
	get_tree().paused = true
	game_over_label.text = "Game Over\nRun ended - press R to restart"
	game_over_label.visible = true
	run_summary_label.text = "Run Summary\nRun Time: %s\nFinal Score: %s\nEnemies Defeated: %s\nLevel Reached: %s\nWave Reached: %s" % [
		_format_time(elapsed_time),
		score,
		enemies_defeated,
		level,
		wave,
	]
	run_summary_label.text += "\nUpgrades: %s" % _upgrade_summary()
	run_summary_label.visible = true
	_update_status("Run ended. Press R to restart.")

func _update_defeated_count() -> void:
	defeated_count_label.text = "Defeated: %s" % enemies_defeated

func _update_score() -> void:
	score_label.text = "Score: %s" % score

func _update_xp_count() -> void:
	xp_count_label.text = "XP: %s" % xp

func _update_level() -> void:
	level_label.text = "Level: %s" % level

func _update_wave() -> void:
	wave_label.text = "Wave: %s" % wave

func _update_time() -> void:
	time_label.text = "Run Time: %s" % _format_time(elapsed_time)

func _update_upgrade_count() -> void:
	var latest := "None"
	if not selected_upgrades.is_empty():
		latest = selected_upgrades[selected_upgrades.size() - 1]
	upgrade_count_label.text = "Upgrades: %s | Latest: %s" % [selected_upgrades.size(), latest]

func _update_status(message: String) -> void:
	status_label.text = message

func _upgrade_summary() -> String:
	if selected_upgrades.is_empty():
		return "None selected"
	return ", ".join(selected_upgrades)

func _format_time(time_seconds: float) -> String:
	var total_seconds := int(time_seconds)
	var minutes := int(total_seconds / 60)
	var seconds := total_seconds % 60
	return "%02d:%02d" % [minutes, seconds]

func _configure_enemy(enemy_node: Node) -> void:
	if enemy_node.has_method("configure_for_difficulty"):
		enemy_node.configure_for_difficulty(wave, _time_scaling_tier())
	elif enemy_node.has_method("configure_for_wave"):
		enemy_node.configure_for_wave(wave)

func _time_scaling_tier() -> int:
	if elapsed_time >= 60.0:
		return 2
	if elapsed_time >= 30.0:
		return 1
	return 0

func _award_survival_milestone() -> void:
	milestone_awarded = true
	score += milestone_score_bonus
	_update_score()
	_update_status("Milestone reached: %s seconds survived. Choose a reward." % int(milestone_time))
	print("Milestone reached: %s seconds survived! +%s score" % [int(milestone_time), milestone_score_bonus])
	_start_upgrade_choice("Milestone reached: %s seconds survived!\n+%s bonus score\nGame Paused" % [int(milestone_time), milestone_score_bonus])

func _start_upgrade_choice(prompt_text: String = "") -> void:
	if choosing_upgrade:
		return

	# Main keeps processing while paused so number-key upgrade choices can resume the run.
	level += 1
	xp = 0
	choosing_upgrade = true
	next_timed_upgrade_at = elapsed_time + timed_upgrade_interval
	current_upgrade_choices = _deal_upgrade_choices()
	get_tree().paused = true
	upgrade_choice_label.visible = true
	level_up_label.visible = true
	if prompt_text == "":
		level_up_label.text = "Level %s Reached\nGame Paused" % level
	else:
		level_up_label.text = prompt_text
	upgrade_choice_label.text = _format_upgrade_choices()
	_update_status("Game paused. Choose upgrade 1, 2, or 3.")
	_update_level()
	_update_xp_count()
	print("Level up! Gameplay paused. Choose one of the dealt upgrades with 1, 2, or 3.")

func _deal_upgrade_choices() -> Array[Dictionary]:
	var pool := _upgrade_pool()
	pool.shuffle()
	return pool.slice(0, 3)

func _upgrade_pool() -> Array[Dictionary]:
	return [
		{
			"id": "move_speed",
			"name": "Move Speed Up",
			"description": "+%s move speed" % speed_upgrade_amount,
		},
		{
			"id": "attack_speed",
			"name": "Attack Speed Up",
			"description": "-%ss basic attack cooldown" % attack_speed_upgrade_amount,
		},
		{
			"id": "damage",
			"name": "Damage Up",
			"description": "+%s attack damage" % attack_damage_upgrade_amount,
		},
		{
			"id": "max_health",
			"name": "Max Health Up",
			"description": "+%s max health and heal" % max_health_upgrade_amount,
		},
		{
			"id": "pickup_radius",
			"name": "Pickup Radius Up",
			"description": "+%s pickup radius" % pickup_radius_upgrade_amount,
		},
		{
			"id": "secondary_damage",
			"name": "Secondary Damage Up",
			"description": "+%s secondary burst damage" % secondary_damage_upgrade_amount,
		},
		{
			"id": "secondary_cooldown",
			"name": "Secondary Cooldown Down",
			"description": "-%ss secondary burst cooldown" % secondary_cooldown_upgrade_amount,
		},
		{
			"id": "secondary_radius",
			"name": "Secondary Radius Up",
			"description": "+%s secondary burst radius" % secondary_radius_upgrade_amount,
		},
		{
			"id": "health_drop_chance",
			"name": "Health Drop Chance Up",
			"description": "+%s%% health pickup drop chance" % int(health_drop_chance_upgrade_amount * 100),
		},
	]

func _format_upgrade_choices() -> String:
	var lines: Array[String] = ["GAME PAUSED - Choose 1 upgrade card"]
	for index in range(current_upgrade_choices.size()):
		var choice := current_upgrade_choices[index]
		lines.append("")
		lines.append("%s - %s" % [index + 1, choice["name"]])
		lines.append("    %s" % choice["description"])
	return "\n".join(lines)

func _select_upgrade(choice_index: int) -> void:
	if choice_index >= current_upgrade_choices.size():
		return

	var choice := current_upgrade_choices[choice_index]
	_apply_upgrade(choice)

func _apply_upgrade(choice: Dictionary) -> void:
	match choice["id"]:
		"move_speed":
			player.speed += speed_upgrade_amount
		"attack_speed":
			player.attack_cooldown = max(0.12, player.attack_cooldown - attack_speed_upgrade_amount)
		"damage":
			player.attack_damage += attack_damage_upgrade_amount
		"max_health":
			player.max_health += max_health_upgrade_amount
			player.health = player.max_health
		"pickup_radius":
			player.pickup_radius += pickup_radius_upgrade_amount
		"secondary_damage":
			player.secondary_attack_damage += secondary_damage_upgrade_amount
		"secondary_cooldown":
			player.secondary_attack_cooldown = max(0.75, player.secondary_attack_cooldown - secondary_cooldown_upgrade_amount)
		"secondary_radius":
			player.secondary_attack_radius += secondary_radius_upgrade_amount
			player.refresh_secondary_attack_radius()
		"health_drop_chance":
			health_pickup_drop_chance = min(max_health_pickup_drop_chance, health_pickup_drop_chance + health_drop_chance_upgrade_amount)

	selected_upgrades.append(choice["name"])
	choosing_upgrade = false
	get_tree().paused = false
	upgrade_choice_label.visible = false
	level_up_label.text = "Level %s Upgrade: %s\nRun Resumed" % [level, choice["name"]]
	level_up_label.visible = true
	_update_upgrade_count()
	_update_status("Objective: survive, collect XP, and reach the next reward.")
	print("Upgrade selected: %s" % choice["name"])

func _start_run() -> void:
	game_state = GameState.PLAYING
	get_tree().paused = false
	start_label.visible = false
	_update_status("Objective: survive 60 seconds, collect XP, and choose upgrades.")
	print("Run started")
