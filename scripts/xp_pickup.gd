extends Area2D

@export var xp_value: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.name == "Player":
		return

	if get_tree().current_scene.has_method("collect_xp"):
		get_tree().current_scene.collect_xp(xp_value)
	queue_free()
