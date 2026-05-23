extends Node

@export var audio_enabled: bool = true
@export var master_volume_db: float = -12.0

var sounds: Dictionary = {}
var players: Dictionary = {}

func _ready() -> void:
	sounds = {
		"player_attack": _make_tone(520.0, 0.06),
		"secondary_burst": _make_tone(220.0, 0.16),
		"enemy_defeat": _make_tone(140.0, 0.18),
		"pickup": _make_tone(760.0, 0.1),
		"player_damage": _make_tone(90.0, 0.14),
	}

	for sound_name in sounds.keys():
		var player := AudioStreamPlayer.new()
		player.name = "%sPlayer" % sound_name.capitalize().replace(" ", "")
		player.stream = sounds[sound_name]
		player.volume_db = master_volume_db
		add_child(player)
		players[sound_name] = player

func play_player_attack() -> void:
	_play("player_attack")

func play_secondary_burst() -> void:
	_play("secondary_burst")

func play_enemy_defeat() -> void:
	_play("enemy_defeat")

func play_pickup() -> void:
	_play("pickup")

func play_player_damage() -> void:
	_play("player_damage")

func _play(sound_name: String) -> void:
	if not audio_enabled:
		return

	var player = players.get(sound_name)
	if player == null:
		return

	player.volume_db = master_volume_db
	player.play()

func _make_tone(frequency: float, duration: float) -> AudioStreamWAV:
	var sample_rate := 22050
	var sample_count := int(sample_rate * duration)
	var data := PackedByteArray()
	data.resize(sample_count * 2)

	for index in range(sample_count):
		var progress := float(index) / float(sample_count)
		var fade := 1.0 - progress
		var sample := sin(TAU * frequency * float(index) / float(sample_rate)) * fade * 0.45
		var value := int(sample * 32767.0)
		if value < 0:
			value = 65536 + value
		data[index * 2] = value & 0xff
		data[(index * 2) + 1] = (value >> 8) & 0xff

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.data = data
	return stream
