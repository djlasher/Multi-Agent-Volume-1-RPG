extends Label

@export var lifetime: float = 0.75
@export var float_speed: float = 42.0

var age: float = 0.0

func setup(message: String, text_color: Color) -> void:
	text = message
	modulate = text_color
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _process(delta: float) -> void:
	age += delta
	position.y -= float_speed * delta
	modulate.a = max(0.0, 1.0 - (age / lifetime))
	if age >= lifetime:
		queue_free()
