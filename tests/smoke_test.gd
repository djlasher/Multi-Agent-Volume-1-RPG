extends SceneTree

const REQUIRED_RESOURCES := [
	"res://scenes/main.tscn",
	"res://scenes/player.tscn",
	"res://scenes/enemy.tscn",
	"res://scenes/rusher_enemy.tscn",
	"res://scenes/xp_pickup.tscn",
	"res://scenes/health_pickup.tscn",
	"res://scripts/main.gd",
	"res://scripts/player.gd",
	"res://scripts/enemy.gd",
	"res://scripts/xp_pickup.gd",
	"res://scripts/health_pickup.gd",
]

const REQUIRED_NODES := [
	"Player",
	"EnemySpawnPoint",
	"GameUI",
	"GameUI/DefeatedCountLabel",
	"GameUI/ScoreLabel",
	"GameUI/XPCountLabel",
	"GameUI/LevelLabel",
	"GameUI/WaveLabel",
	"GameUI/TimeLabel",
	"GameUI/UpgradeCountLabel",
	"GameUI/StatusLabel",
	"GameUI/StartLabel",
	"GameUI/UpgradeChoiceLabel",
	"GameUI/RunSummaryLabel",
	"GameUI/GameOverLabel",
]

func _initialize() -> void:
	var failures: Array[String] = []

	_check_required_resources(failures)
	var main_scene := _load_main_scene(failures)
	if main_scene != null:
		_check_main_scene(main_scene, failures)
		main_scene.free()

	if failures.is_empty():
		print("Smoke test passed.")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)

func _check_required_resources(failures: Array[String]) -> void:
	for path in REQUIRED_RESOURCES:
		if not ResourceLoader.exists(path):
			failures.append("Missing required resource: %s" % path)

func _load_main_scene(failures: Array[String]) -> Node:
	var packed_scene := load("res://scenes/main.tscn")
	if packed_scene == null:
		failures.append("Could not load res://scenes/main.tscn")
		return null

	var instance: Node = packed_scene.instantiate()
	if instance == null:
		failures.append("Could not instantiate main scene")
	return instance

func _check_main_scene(main_scene: Node, failures: Array[String]) -> void:
	if main_scene.get_script() == null:
		failures.append("Main scene is missing its script")

	for node_path in REQUIRED_NODES:
		if main_scene.get_node_or_null(node_path) == null:
			failures.append("Main scene missing node: %s" % node_path)

	var player := main_scene.get_node_or_null("Player")
	if player != null and player.get_script() == null:
		failures.append("Player is missing its script")
	if player != null and player.get_node_or_null("SecondaryAttackArea") == null:
		failures.append("Player is missing SecondaryAttackArea")
	if player != null and player.get_node_or_null("SecondaryAttackArea/SecondaryAttackShape") == null:
		failures.append("Player is missing SecondaryAttackShape")

	var enemy_scene := load("res://scenes/enemy.tscn")
	if enemy_scene == null:
		failures.append("Could not load enemy scene")
	else:
		var enemy: Node = enemy_scene.instantiate()
		if enemy == null:
			failures.append("Could not instantiate enemy scene")
		elif enemy.get_script() == null:
			failures.append("Enemy is missing its script")
		if enemy != null:
			enemy.free()

	var rusher_enemy_scene := load("res://scenes/rusher_enemy.tscn")
	if rusher_enemy_scene == null:
		failures.append("Could not load rusher enemy scene")
	else:
		var rusher_enemy: Node = rusher_enemy_scene.instantiate()
		if rusher_enemy == null:
			failures.append("Could not instantiate rusher enemy scene")
		elif rusher_enemy.get_script() == null:
			failures.append("Rusher enemy is missing its script")
		if rusher_enemy != null:
			rusher_enemy.free()

	var xp_pickup_scene := load("res://scenes/xp_pickup.tscn")
	if xp_pickup_scene == null:
		failures.append("Could not load XP pickup scene")
	else:
		var xp_pickup: Node = xp_pickup_scene.instantiate()
		if xp_pickup == null:
			failures.append("Could not instantiate XP pickup scene")
		elif xp_pickup.get_script() == null:
			failures.append("XP pickup is missing its script")
		if xp_pickup != null:
			xp_pickup.free()

	var health_pickup_scene := load("res://scenes/health_pickup.tscn")
	if health_pickup_scene == null:
		failures.append("Could not load health pickup scene")
	else:
		var health_pickup: Node = health_pickup_scene.instantiate()
		if health_pickup == null:
			failures.append("Could not instantiate health pickup scene")
		elif health_pickup.get_script() == null:
			failures.append("Health pickup is missing its script")
		if health_pickup != null:
			health_pickup.free()
