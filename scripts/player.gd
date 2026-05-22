extends CharacterBody2D

@export var speed: float = 220.0
@export var max_health: int = 3

var health: int = max_health
var hit_flash_time: float = 0.0
var game_over: bool = false

@onready var body: ColorRect = $Body
@onready var game_over_label: Label = get_tree().current_scene.get_node_or_null("GameUI/GameOverLabel") as Label

func _physics_process(_delta: float) -> void:
	if game_over:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

	if hit_flash_time > 0.0:
		hit_flash_time -= _delta
		if hit_flash_time <= 0.0:
			body.color = Color(0.22, 0.74, 0.52, 1)

func take_hit() -> void:
	if game_over:
		return

	health = max(health - 1, 0)
	body.color = Color(1.0, 0.86, 0.16, 1)
	hit_flash_time = 0.25
	print("Player health: %s/%s" % [health, max_health])

	if health == 0:
		_show_game_over()

func _unhandled_input(event: InputEvent) -> void:
	if not game_over:
		return

	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		get_tree().reload_current_scene()

func _show_game_over() -> void:
	game_over = true
	velocity = Vector2.ZERO
	body.color = Color(1.0, 0.22, 0.22, 1)
	if game_over_label != null:
		game_over_label.visible = true
	print("Game Over - press R to restart")
