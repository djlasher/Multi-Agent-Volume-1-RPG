extends Node2D

const ENEMY_SCENE := preload("res://scenes/enemy.tscn")

@export var enemy_respawn_delay: float = 1.25

var enemies_defeated: int = 0

@onready var defeated_count_label: Label = $GameUI/DefeatedCountLabel
@onready var enemy_spawn_point: Node2D = $EnemySpawnPoint

func _ready() -> void:
	_update_defeated_count()

func enemy_defeated() -> void:
	enemies_defeated += 1
	_update_defeated_count()
	print("Enemies defeated: %s" % enemies_defeated)
	_respawn_enemy_after_delay()

func _respawn_enemy_after_delay() -> void:
	await get_tree().create_timer(enemy_respawn_delay).timeout
	var enemy := ENEMY_SCENE.instantiate()
	enemy.position = enemy_spawn_point.position
	add_child(enemy)

func _update_defeated_count() -> void:
	defeated_count_label.text = "Enemies defeated: %s" % enemies_defeated
