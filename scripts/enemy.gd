extends Area2D

@export var speed: float = 45.0
@export var max_health: int = 2

var player: Node2D
var health: int = max_health
var defeated: bool = false

func _ready() -> void:
	player = get_tree().current_scene.get_node_or_null("Player")
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if defeated or player == null:
		return

	var direction := global_position.direction_to(player.global_position)
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if defeated:
		return

	if body.has_method("take_hit"):
		body.take_hit()

func take_damage(amount: int) -> void:
	if defeated:
		return

	health = max(health - amount, 0)
	print("Enemy health: %s/%s" % [health, max_health])

	if health == 0:
		defeated = true
		print("Enemy defeated")
		if get_tree().current_scene.has_method("enemy_defeated"):
			get_tree().current_scene.enemy_defeated(global_position)
		queue_free()

func configure_for_wave(wave: int) -> void:
	speed = 45.0 + ((wave - 1) * 10.0)
	max_health = 2 + (wave - 1)
	health = max_health
