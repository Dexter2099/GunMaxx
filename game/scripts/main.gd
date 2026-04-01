extends Node2D

@onready var camera: Camera2D = $Player/Camera2D
@onready var player: CharacterBody2D = $Player
@onready var room_clear_label: Label = $RoomClearLabel
@onready var room_clear_timer: Timer = $RoomClearTimer

const ROOM_SIZE := Vector2(1024, 640)

var encounter_enemies: Array[Node] = []
var encounter_enemies_alive: int = 0
var is_restarting: bool = false
var room_cleared: bool = false

func _ready() -> void:
	var half := ROOM_SIZE * 0.5
	camera.limit_left = int(-half.x)
	camera.limit_top = int(-half.y)
	camera.limit_right = int(half.x)
	camera.limit_bottom = int(half.y)

	if player.has_signal("died"):
		player.died.connect(_on_player_died)

	room_clear_timer.timeout.connect(_on_room_clear_timer_timeout)
	collect_encounter_enemies()

	if encounter_enemies_alive == 0:
		on_room_cleared()

func collect_encounter_enemies() -> void:
	encounter_enemies.clear()

	for child in get_children():
		if child.is_in_group("enemies"):
			encounter_enemies.append(child)
			child.tree_exited.connect(_on_encounter_enemy_removed)

	encounter_enemies_alive = encounter_enemies.size()

func _on_encounter_enemy_removed() -> void:
	if room_cleared or is_restarting:
		return

	encounter_enemies_alive = max(encounter_enemies_alive - 1, 0)
	if encounter_enemies_alive == 0:
		on_room_cleared()

func on_room_cleared() -> void:
	if room_cleared or is_restarting:
		return

	room_cleared = true
	room_clear_label.visible = true
	room_clear_timer.start()

func _on_player_died() -> void:
	restart_room()

func _on_room_clear_timer_timeout() -> void:
	restart_room()

func restart_room() -> void:
	if is_restarting:
		return

	is_restarting = true
	get_tree().reload_current_scene()
