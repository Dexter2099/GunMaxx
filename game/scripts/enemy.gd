extends CharacterBody2D

signal died

@export var move_speed: float = 120.0
@export var contact_damage: int = 1
@export var contact_damage_interval: float = 0.4
@export var contact_range: float = 40.0

var player: Node2D
var contact_damage_cooldown_left: float = 0.0
var is_dead: bool = false

func _ready() -> void:
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player") as Node2D

func _physics_process(delta: float) -> void:
	if contact_damage_cooldown_left > 0.0:
		contact_damage_cooldown_left -= delta

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
	try_contact_damage()

func try_contact_damage() -> void:
	if player == null or not is_instance_valid(player):
		return

	if contact_damage_cooldown_left > 0.0:
		return

	if global_position.distance_to(player.global_position) > contact_range:
		return

	if player.has_method("take_damage"):
		player.take_damage(contact_damage)
		contact_damage_cooldown_left = contact_damage_interval

func die() -> void:
	if is_dead:
		return

	is_dead = true
	died.emit()
	queue_free()
