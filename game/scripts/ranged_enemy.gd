extends CharacterBody2D

signal died

@export var fire_cooldown: float = 1.1
@export var projectile_spawn_distance: float = 24.0

const ENEMY_PROJECTILE_SCENE := preload("res://scenes/EnemyProjectile.tscn")

var player: Node2D
var fire_cooldown_left: float = 0.0
var is_dead: bool = false

func _ready() -> void:
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player") as Node2D

func _physics_process(delta: float) -> void:
	if fire_cooldown_left > 0.0:
		fire_cooldown_left -= delta

	velocity = Vector2.ZERO

	if player == null or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player") as Node2D
		move_and_slide()
		return

	var to_player := player.global_position - global_position
	if to_player != Vector2.ZERO:
		look_at(player.global_position)

	move_and_slide()
	try_fire(to_player)

func try_fire(to_player: Vector2) -> void:
	if fire_cooldown_left > 0.0:
		return

	if to_player == Vector2.ZERO:
		return

	var direction := to_player.normalized()
	var projectile := ENEMY_PROJECTILE_SCENE.instantiate()
	var spawn_position := global_position + direction * projectile_spawn_distance
	projectile.setup(spawn_position, direction, self)
	get_tree().current_scene.add_child(projectile)
	fire_cooldown_left = fire_cooldown

func die() -> void:
	if is_dead:
		return

	is_dead = true
	died.emit()
	queue_free()
