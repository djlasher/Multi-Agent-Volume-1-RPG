extends Area2D

@export var xp_value: int = 1

var player: Node2D
var collected: bool = false

func _ready() -> void:
	player = get_tree().current_scene.get_node_or_null("Player")
	body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	if collected or player == null:
		return

	var radius = player.get("pickup_radius")
	if radius != null and global_position.distance_to(player.global_position) <= radius:
		_collect()

func _on_body_entered(body: Node2D) -> void:
	if not body.name == "Player":
		return

	_collect()

func _collect() -> void:
	if collected:
		return

	collected = true
	if get_tree().current_scene.has_method("collect_xp"):
		get_tree().current_scene.collect_xp(xp_value)
	queue_free()
