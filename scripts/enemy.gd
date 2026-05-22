extends Area2D

@export var speed: float = 45.0

var player: Node2D

func _ready() -> void:
	player = get_tree().current_scene.get_node_or_null("Player")
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var direction := global_position.direction_to(player.global_position)
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_hit"):
		body.take_hit()
