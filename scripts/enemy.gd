extends Area2D

@export var speed: float = 45.0
@export var max_health: int = 2
@export var knockback_strength: float = 140.0

var player: Node2D
var health: int = max_health
var defeated: bool = false
var hit_feedback_time: float = 0.0
var knockback_velocity: Vector2 = Vector2.ZERO

@onready var body: ColorRect = $Body

func _ready() -> void:
	add_to_group("enemies")
	player = get_tree().current_scene.get_node_or_null("Player")
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if defeated or player == null:
		return

	if hit_feedback_time > 0.0:
		hit_feedback_time -= delta
		if hit_feedback_time <= 0.0:
			body.color = Color(0.82, 0.18, 0.18, 1)
			scale = Vector2.ONE

	if knockback_velocity.length() > 1.0:
		global_position += knockback_velocity * delta
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_strength * 4.0 * delta)

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
	_show_hit_feedback()
	print("Enemy health: %s/%s" % [health, max_health])

	if health == 0:
		defeated = true
		print("Enemy defeated")
		if get_tree().current_scene.has_method("enemy_defeated"):
			get_tree().current_scene.enemy_defeated(global_position)
		queue_free()

func configure_for_wave(wave: int) -> void:
	configure_for_difficulty(wave, 0)

func configure_for_difficulty(wave: int, time_tier: int) -> void:
	speed = 45.0 + ((wave - 1) * 10.0) + (time_tier * 15.0)
	max_health = 2 + (wave - 1) + time_tier
	health = max_health

func _show_hit_feedback() -> void:
	body.color = Color(1.0, 0.78, 0.25, 1)
	scale = Vector2(1.12, 1.12)
	hit_feedback_time = 0.12
	if player != null:
		knockback_velocity = player.global_position.direction_to(global_position) * knockback_strength
