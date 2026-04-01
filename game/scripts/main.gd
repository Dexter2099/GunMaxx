extends Node2D

@onready var camera: Camera2D = $Player/Camera2D
@onready var player: CharacterBody2D = $Player
@onready var room_controller: Node = $RoomController
@onready var health_label: Label = $HUD/MarginContainer/HBoxContainer/HealthLabel
@onready var room_state_label: Label = $HUD/MarginContainer/HBoxContainer/RoomStateLabel
@onready var room_counter_label: Label = $HUD/MarginContainer/HBoxContainer/RoomCounterLabel
@onready var room_clear_timer: Timer = $RoomClearTimer

const ROOM_SIZE := Vector2(1536, 960)
const CHASER_ENEMY_SCENE := preload("res://scenes/Enemy.tscn")
const TURRET_ENEMY_SCENE := preload("res://scenes/RangedEnemy.tscn")
const HEALTH_PICKUP_SCENE := preload("res://scenes/HealthPickup.tscn")

var is_restarting: bool = false
var room_cleared: bool = false
var room_number: int = 1
var active_health_pickup: Area2D = null

func _ready() -> void:
	var half := ROOM_SIZE * 0.5
	camera.limit_left = int(-half.x)
	camera.limit_top = int(-half.y)
	camera.limit_right = int(half.x)
	camera.limit_bottom = int(half.y)

	if player.has_signal("died"):
		player.died.connect(_on_player_died)
	if player.has_signal("health_changed"):
		player.health_changed.connect(_on_player_health_changed)
	if room_controller.has_signal("room_cleared"):
		room_controller.room_cleared.connect(on_room_cleared)

	room_clear_timer.timeout.connect(_on_room_clear_timer_timeout)
	if player.has_method("get_health") and player.has_method("get_max_health"):
		_on_player_health_changed(player.get_health(), player.get_max_health())
	_set_room_state_text(false)
	_update_room_counter()
	_set_room_encounter_composition(room_number)

func _on_player_health_changed(current: int, max_value: int) -> void:
	health_label.text = "HP: %d/%d" % [current, max_value]

func on_room_cleared() -> void:
	if room_cleared or is_restarting:
		return

	room_cleared = true
	_set_room_state_text(true)
	if _spawn_health_pickup_if_needed():
		return
	room_clear_timer.start()

func _on_player_died() -> void:
	restart_room()

func _on_room_clear_timer_timeout() -> void:
	start_next_room()


func start_next_room() -> void:
	if is_restarting:
		return

	_clear_active_health_pickup()
	room_number += 1
	room_cleared = false
	_set_room_state_text(false)
	_update_room_counter()
	_set_room_encounter_composition(room_number)

	if room_controller.has_method("start_next_encounter"):
		room_controller.start_next_encounter()
	else:
		room_controller.start_encounter()

func _spawn_health_pickup_if_needed() -> bool:
	if not player.has_method("get_health") or not player.has_method("get_max_health"):
		return false

	if player.get_health() >= player.get_max_health():
		return false

	var pickup := HEALTH_PICKUP_SCENE.instantiate() as Area2D
	if pickup == null:
		return false

	pickup.global_position = Vector2(0, -36)
	add_child(pickup)
	active_health_pickup = pickup
	if pickup.has_signal("collected"):
		pickup.collected.connect(_on_health_pickup_collected)
	pickup.tree_exited.connect(_on_health_pickup_tree_exited.bind(pickup))
	return true

func _on_health_pickup_collected() -> void:
	if is_restarting or not room_cleared:
		return
	room_clear_timer.start()

func _on_health_pickup_tree_exited(pickup: Area2D) -> void:
	if active_health_pickup == pickup:
		active_health_pickup = null

func _clear_active_health_pickup() -> void:
	if active_health_pickup != null and is_instance_valid(active_health_pickup):
		active_health_pickup.queue_free()
	active_health_pickup = null

func restart_room() -> void:
	if is_restarting:
		return

	is_restarting = true
	_clear_active_health_pickup()
	get_tree().reload_current_scene()

func _set_room_state_text(cleared: bool) -> void:
	room_state_label.text = "CLEARED" if cleared else "FIGHT"

func _update_room_counter() -> void:
	room_counter_label.text = "ROOM %d" % room_number

func _set_room_encounter_composition(room_index: int) -> void:
	if room_controller == null:
		return

	room_controller.enemy_scenes = _build_encounter_for_room(room_index)

func _build_encounter_for_room(room_index: int) -> Array[PackedScene]:
	if room_index <= 1:
		return [CHASER_ENEMY_SCENE, TURRET_ENEMY_SCENE, CHASER_ENEMY_SCENE]
	if room_index == 2:
		return [CHASER_ENEMY_SCENE, CHASER_ENEMY_SCENE, TURRET_ENEMY_SCENE, CHASER_ENEMY_SCENE]
	if room_index == 3:
		return [CHASER_ENEMY_SCENE, TURRET_ENEMY_SCENE, CHASER_ENEMY_SCENE, TURRET_ENEMY_SCENE]
	if room_index == 4:
		return [CHASER_ENEMY_SCENE, CHASER_ENEMY_SCENE, TURRET_ENEMY_SCENE, TURRET_ENEMY_SCENE, CHASER_ENEMY_SCENE]

	return [CHASER_ENEMY_SCENE, TURRET_ENEMY_SCENE, CHASER_ENEMY_SCENE, TURRET_ENEMY_SCENE, TURRET_ENEMY_SCENE]
