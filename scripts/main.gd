extends Node2D

const ENEMY_SCENE := preload("res://scenes/enemy.tscn")
const XP_PICKUP_SCENE := preload("res://scenes/xp_pickup.tscn")

@export var enemy_respawn_delay: float = 1.25
@export var xp_to_level: int = 3
@export var speed_upgrade_amount: float = 25.0
@export var attack_damage_upgrade_amount: int = 1
@export var max_health_upgrade_amount: int = 1
@export var enemies_per_wave: int = 3

var enemies_defeated: int = 0
var xp: int = 0
var level: int = 1
var wave: int = 1
var choosing_upgrade: bool = false

@onready var defeated_count_label: Label = $GameUI/DefeatedCountLabel
@onready var xp_count_label: Label = $GameUI/XPCountLabel
@onready var level_label: Label = $GameUI/LevelLabel
@onready var wave_label: Label = $GameUI/WaveLabel
@onready var level_up_label: Label = $GameUI/LevelUpLabel
@onready var upgrade_choice_label: Label = $GameUI/UpgradeChoiceLabel
@onready var enemy_spawn_point: Node2D = $EnemySpawnPoint
@onready var player = $Player
@onready var enemy = $Enemy

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_update_defeated_count()
	_update_xp_count()
	_update_level()
	_update_wave()
	_configure_enemy(enemy)
	level_up_label.visible = false
	upgrade_choice_label.visible = false

func enemy_defeated(defeat_position: Vector2) -> void:
	enemies_defeated += 1
	var next_wave := int(enemies_defeated / enemies_per_wave) + 1
	if next_wave != wave:
		wave = next_wave
		_update_wave()
		print("Wave: %s" % wave)
	_update_defeated_count()
	print("Enemies defeated: %s" % enemies_defeated)
	_spawn_xp_pickup(defeat_position)
	_respawn_enemy_after_delay()

func collect_xp(amount: int) -> void:
	xp += amount
	if xp >= xp_to_level:
		_start_upgrade_choice()
	_update_xp_count()
	print("XP: %s" % xp)

func _unhandled_input(event: InputEvent) -> void:
	if not choosing_upgrade:
		return

	if not event is InputEventKey or not event.pressed or event.echo:
		return

	if event.keycode == KEY_1:
		_apply_upgrade("Speed increased", func() -> void: player.speed += speed_upgrade_amount)
	elif event.keycode == KEY_2:
		_apply_upgrade("Attack damage increased", func() -> void: player.attack_damage += attack_damage_upgrade_amount)
	elif event.keycode == KEY_3:
		_apply_upgrade("Max health increased and healed", func() -> void:
			player.max_health += max_health_upgrade_amount
			player.health = player.max_health
		)

func _respawn_enemy_after_delay() -> void:
	await get_tree().create_timer(enemy_respawn_delay, false).timeout
	var new_enemy := ENEMY_SCENE.instantiate()
	new_enemy.position = enemy_spawn_point.position
	_configure_enemy(new_enemy)
	add_child(new_enemy)

func _spawn_xp_pickup(spawn_position: Vector2) -> void:
	var pickup := XP_PICKUP_SCENE.instantiate()
	pickup.position = spawn_position
	add_child(pickup)

func _update_defeated_count() -> void:
	defeated_count_label.text = "Enemies defeated: %s" % enemies_defeated

func _update_xp_count() -> void:
	xp_count_label.text = "XP: %s" % xp

func _update_level() -> void:
	level_label.text = "Level: %s" % level

func _update_wave() -> void:
	wave_label.text = "Wave: %s" % wave

func _configure_enemy(enemy_node: Node) -> void:
	if enemy_node.has_method("configure_for_wave"):
		enemy_node.configure_for_wave(wave)

func _start_upgrade_choice() -> void:
	if choosing_upgrade:
		return

	level += 1
	xp = 0
	choosing_upgrade = true
	get_tree().paused = true
	upgrade_choice_label.visible = true
	level_up_label.visible = true
	_update_level()
	_update_xp_count()
	print("Level up! Choose an upgrade with 1, 2, or 3.")

func _apply_upgrade(message: String, apply_upgrade: Callable) -> void:
	apply_upgrade.call()
	choosing_upgrade = false
	get_tree().paused = false
	upgrade_choice_label.visible = false
	level_up_label.text = "Level %s: %s" % [level, message]
	level_up_label.visible = true
	print("Upgrade selected: %s" % message)
