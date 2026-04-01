extends Node2D

@onready var camera: Camera2D = $Player/Camera2D
@onready var player: CharacterBody2D = $Player

const ROOM_SIZE := Vector2(1024, 640)

func _ready() -> void:
	var half := ROOM_SIZE * 0.5
	camera.limit_left = int(-half.x)
	camera.limit_top = int(-half.y)
	camera.limit_right = int(half.x)
	camera.limit_bottom = int(half.y)

	if player.has_signal("died"):
		player.died.connect(_on_player_died)

func _on_player_died() -> void:
	get_tree().reload_current_scene()
