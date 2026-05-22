extends Node2D

const ENEMY_SCENE := preload("res://scenes/enemy.tscn")
const XP_PICKUP_SCENE := preload("res://scenes/xp_pickup.tscn")

@export var enemy_respawn_delay: float = 1.25
@export var xp_to_level: int = 3
@export var speed_increase_per_level: float = 25.0

var enemies_defeated: int = 0
var xp: int = 0
var level: int = 1

@onready var defeated_count_label: Label = $GameUI/DefeatedCountLabel
@onready var xp_count_label: Label = $GameUI/XPCountLabel
@onready var level_label: Label = $GameUI/LevelLabel
@onready var level_up_label: Label = $GameUI/LevelUpLabel
@onready var enemy_spawn_point: Node2D = $EnemySpawnPoint
@onready var player = $Player

func _ready() -> void:
	_update_defeated_count()
	_update_xp_count()
	_update_level()
	level_up_label.visible = false

func enemy_defeated(defeat_position: Vector2) -> void:
	enemies_defeated += 1
	_update_defeated_count()
	print("Enemies defeated: %s" % enemies_defeated)
	_spawn_xp_pickup(defeat_position)
	_respawn_enemy_after_delay()

func collect_xp(amount: int) -> void:
	xp += amount
	if xp >= xp_to_level:
		_level_up()
	_update_xp_count()
	print("XP: %s" % xp)

func _respawn_enemy_after_delay() -> void:
	await get_tree().create_timer(enemy_respawn_delay).timeout
	var enemy := ENEMY_SCENE.instantiate()
	enemy.position = enemy_spawn_point.position
	add_child(enemy)

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

func _level_up() -> void:
	level += 1
	xp = 0
	if player != null:
		player.speed += speed_increase_per_level
	level_up_label.text = "Level Up! Speed +%s" % speed_increase_per_level
	level_up_label.visible = true
	_update_level()
	if player != null:
		print("Level up! Level: %s, player speed: %s" % [level, player.speed])
	else:
		print("Level up! Level: %s" % level)
