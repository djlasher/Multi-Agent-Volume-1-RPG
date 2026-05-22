extends CharacterBody2D

@export var speed: float = 220.0
@export var max_health: int = 3

var health: int = max_health
var hit_flash_time: float = 0.0

@onready var body: ColorRect = $Body

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

	if hit_flash_time > 0.0:
		hit_flash_time -= _delta
		if hit_flash_time <= 0.0:
			body.color = Color(0.22, 0.74, 0.52, 1)

func take_hit() -> void:
	health = max(health - 1, 0)
	body.color = Color(1.0, 0.86, 0.16, 1)
	hit_flash_time = 0.25
	print("Player health: %s/%s" % [health, max_health])
