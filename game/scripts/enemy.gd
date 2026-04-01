extends CharacterBody2D

@export var move_speed: float = 120.0

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D

func _physics_process(_delta: float) -> void:
	if player == null or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player") as Node2D
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var to_player := player.global_position - global_position
	if to_player.length() > 1.0:
		velocity = to_player.normalized() * move_speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func die() -> void:
	queue_free()
