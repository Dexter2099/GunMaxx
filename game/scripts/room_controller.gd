extends Node2D

signal room_cleared

@export var enemy_scene: PackedScene
@export var spawn_count: int = 3
@export var ranged_enemy_scene: PackedScene
@export var ranged_spawn_count: int = 1
@export var spawn_points_root: NodePath = ^"SpawnPoints"
@export var enemy_container_path: NodePath = ^"../Enemies"

var room_cleared_flag: bool = false
var active_enemies: Array[Node2D] = []

func _ready() -> void:
	print("[RoomController] _ready() reached")
	call_deferred("start_encounter")

func start_encounter() -> void:
	print("[RoomController] start_encounter() begin")
	room_cleared_flag = false
	active_enemies.clear()

	var spawn_points_node := get_node_or_null(spawn_points_root)
	if spawn_points_node == null:
		push_error("[RoomController] spawn_points_root not found at path: %s" % spawn_points_root)
	else:
		print("[RoomController] spawn_points_root resolved: %s" % spawn_points_node.get_path())

	var enemy_container := get_node_or_null(enemy_container_path)
	if enemy_container == null:
		push_error("[RoomController] enemy container not found at path: %s" % enemy_container_path)
	else:
		print("[RoomController] enemy container resolved: %s" % enemy_container.get_path())

	if spawn_points_node == null or enemy_container == null:
		print("[RoomController] Aborting encounter start due to missing dependencies")
		return

	var spawn_points: Array[Node2D] = []
	for child in spawn_points_node.get_children():
		if child is Node2D:
			spawn_points.append(child)
	print("[RoomController] spawn points found: %d" % spawn_points.size())

	var spawn_scenes: Array[PackedScene] = []
	for i in range(spawn_count):
		if enemy_scene != null:
			spawn_scenes.append(enemy_scene)
	for i in range(ranged_spawn_count):
		if ranged_enemy_scene != null:
			spawn_scenes.append(ranged_enemy_scene)

	if spawn_scenes.is_empty() or spawn_points.is_empty():
		print("[RoomController] no spawning required (melee=%d, ranged=%d)" % [spawn_count, ranged_spawn_count])
		_check_room_cleared()
		return

	var enemies_to_spawn: int = min(spawn_scenes.size(), spawn_points.size())
	var spawned_count := 0
	for i in range(enemies_to_spawn):
		var enemy := spawn_scenes[i].instantiate() as Node2D
		if enemy == null:
			push_error("[RoomController] Failed to instantiate enemy at index %d" % i)
			continue

		enemy.global_position = spawn_points[i].global_position
		enemy_container.add_child(enemy)
		print("[RoomController] Enemy %d spawned at %s" % [i, enemy.global_position])
		_register_enemy(enemy)
		spawned_count += 1

	print("[RoomController] enemies instantiated: %d/%d" % [spawned_count, enemies_to_spawn])

	_check_room_cleared()

func _register_enemy(enemy: Node2D) -> void:
	if active_enemies.has(enemy):
		return

	active_enemies.append(enemy)
	if enemy.has_signal("died"):
		enemy.died.connect(_on_enemy_died.bind(enemy))
	enemy.tree_exited.connect(_on_enemy_tree_exited.bind(enemy))

func _on_enemy_died(enemy: Node2D) -> void:
	_unregister_enemy(enemy)
	_check_room_cleared()

func _on_enemy_tree_exited(enemy: Node2D) -> void:
	if _unregister_enemy(enemy):
		_check_room_cleared()

func _unregister_enemy(enemy: Node2D) -> bool:
	var idx := active_enemies.find(enemy)
	if idx == -1:
		return false

	active_enemies.remove_at(idx)
	return true

func _check_room_cleared() -> void:
	if room_cleared_flag or not active_enemies.is_empty():
		return

	room_cleared_flag = true
	room_cleared.emit()
