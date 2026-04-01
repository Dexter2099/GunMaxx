extends Node

signal room_cleared

@export var enemy_scene: PackedScene
@export var spawn_count: int = 3
@export var spawn_points_root: NodePath = ^"SpawnPoints"

var room_cleared_flag: bool = false
var active_enemies: Array[Node2D] = []

func _ready() -> void:
	start_encounter()

func start_encounter() -> void:
	room_cleared_flag = false
	active_enemies.clear()

	var spawn_points_node := get_node_or_null(spawn_points_root)
	if spawn_points_node == null or enemy_scene == null:
		return

	var spawn_points: Array[Node2D] = []
	for child in spawn_points_node.get_children():
		if child is Node2D:
			spawn_points.append(child)

	if spawn_points.is_empty() or spawn_count <= 0:
		_check_room_cleared()
		return

	var enemies_to_spawn := min(spawn_count, spawn_points.size())
	for i in enemies_to_spawn:
		var enemy := enemy_scene.instantiate() as Node2D
		if enemy == null:
			continue

		enemy.global_position = spawn_points[i].global_position
		get_parent().add_child(enemy)
		_register_enemy(enemy)

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
