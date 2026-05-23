extends CharacterBody2D

@export var speed: float = 220.0
@export var max_health: int = 3
@export var attack_damage: int = 1
@export var attack_cooldown: float = 0.35
@export var pickup_radius: float = 20.0
@export var secondary_attack_damage: int = 2
@export var secondary_attack_cooldown: float = 2.5
@export var secondary_attack_radius: float = 64.0

var health: int = max_health
var hit_flash_time: float = 0.0
var attack_flash_time: float = 0.0
var secondary_attack_flash_time: float = 0.0
var attack_cooldown_remaining: float = 0.0
var secondary_attack_cooldown_remaining: float = 0.0
var game_over: bool = false

@onready var body: ColorRect = $Body
@onready var attack_area: Area2D = $AttackArea
@onready var attack_visual: ColorRect = $AttackArea/AttackVisual
@onready var secondary_attack_area: Area2D = $SecondaryAttackArea
@onready var secondary_attack_shape: CollisionShape2D = $SecondaryAttackArea/SecondaryAttackShape
@onready var secondary_attack_visual: ColorRect = $SecondaryAttackArea/SecondaryAttackVisual
@onready var game_over_label: Label = get_tree().current_scene.get_node_or_null("GameUI/GameOverLabel") as Label

func _ready() -> void:
	_update_secondary_attack_shape()

func _physics_process(_delta: float) -> void:
	if game_over:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

	if attack_cooldown_remaining > 0.0:
		attack_cooldown_remaining -= _delta

	if secondary_attack_cooldown_remaining > 0.0:
		secondary_attack_cooldown_remaining -= _delta

	if hit_flash_time > 0.0:
		hit_flash_time -= _delta
		if hit_flash_time <= 0.0:
			body.color = Color(0.22, 0.74, 0.52, 1)

	if attack_flash_time > 0.0:
		attack_flash_time -= _delta
		if attack_flash_time <= 0.0:
			attack_visual.visible = false

	if secondary_attack_flash_time > 0.0:
		secondary_attack_flash_time -= _delta
		if secondary_attack_flash_time <= 0.0:
			secondary_attack_visual.visible = false

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
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
		_attack()
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		_secondary_attack()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_attack()

func _attack() -> void:
	if attack_cooldown_remaining > 0.0:
		return

	attack_cooldown_remaining = attack_cooldown
	attack_visual.visible = true
	attack_flash_time = 0.12
	print("Player attack")

	for area in attack_area.get_overlapping_areas():
		if area.has_method("take_damage"):
			area.take_damage(attack_damage)

func _secondary_attack() -> void:
	if secondary_attack_cooldown_remaining > 0.0:
		return

	secondary_attack_cooldown_remaining = secondary_attack_cooldown
	secondary_attack_visual.visible = true
	secondary_attack_flash_time = 0.18
	print("Player secondary burst")

	for area in secondary_attack_area.get_overlapping_areas():
		if area.has_method("take_damage"):
			area.take_damage(secondary_attack_damage)

func _update_secondary_attack_shape() -> void:
	var circle_shape := secondary_attack_shape.shape as CircleShape2D
	if circle_shape != null:
		circle_shape.radius = secondary_attack_radius

	secondary_attack_visual.offset_left = -secondary_attack_radius
	secondary_attack_visual.offset_top = -secondary_attack_radius
	secondary_attack_visual.offset_right = secondary_attack_radius
	secondary_attack_visual.offset_bottom = secondary_attack_radius

func _show_game_over() -> void:
	game_over = true
	velocity = Vector2.ZERO
	body.color = Color(1.0, 0.22, 0.22, 1)
	if game_over_label != null:
		game_over_label.visible = true
	if get_tree().current_scene.has_method("player_game_over"):
		get_tree().current_scene.player_game_over()
	print("Game Over - press R to restart")
