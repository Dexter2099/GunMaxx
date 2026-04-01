extends CharacterBody2D

signal died

@export var move_speed: float = 260.0
@export var fire_cooldown: float = 0.2
@export var bullet_spawn_distance: float = 30.0
@export var max_health: int = 5

const BULLET_SCENE := preload("res://scenes/Bullet.tscn")

var fire_cooldown_left: float = 0.0
var health: int
var is_dead: bool = false

func _ready() -> void:
	add_to_group("player")
	health = max_health

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_vector := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if input_vector.length() > 1.0:
		input_vector = input_vector.normalized()

	velocity = input_vector * move_speed
	move_and_slide()

	var aim_direction := (get_global_mouse_position() - global_position).normalized()
	look_at(get_global_mouse_position())

	if fire_cooldown_left > 0.0:
		fire_cooldown_left -= delta

	if Input.is_action_just_pressed("shoot") and fire_cooldown_left <= 0.0:
		fire_bullet(aim_direction)
		fire_cooldown_left = fire_cooldown

func fire_bullet(aim_direction: Vector2) -> void:
	if aim_direction == Vector2.ZERO:
		return

	var bullet := BULLET_SCENE.instantiate()
	var spawn_position := global_position + aim_direction * bullet_spawn_distance
	bullet.setup(spawn_position, aim_direction, self)
	get_tree().current_scene.add_child(bullet)

func take_damage(amount: int) -> void:
	if is_dead:
		return

	health = max(health - amount, 0)
	if health == 0:
		die()

func die() -> void:
	if is_dead:
		return

	is_dead = true
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	died.emit()
