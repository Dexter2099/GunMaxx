extends Node2D

@onready var camera: Camera2D = $Player/Camera2D
@onready var player: CharacterBody2D = $Player
@onready var room_controller: Node = $RoomController
@onready var room_clear_label: Label = $RoomClearLabel
@onready var room_clear_timer: Timer = $RoomClearTimer

const ROOM_SIZE := Vector2(1024, 640)

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
	if room_controller.has_signal("room_cleared"):
		room_controller.room_cleared.connect(on_room_cleared)

	room_clear_timer.timeout.connect(_on_room_clear_timer_timeout)

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
