extends Area2D

@export var speed: float = 360.0
@export var damage: int = 1
@export var max_lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT
var lifetime_left: float = 0.0
var shooter: Node2D = null

func _ready() -> void:
	lifetime_left = max_lifetime
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func setup(spawn_position: Vector2, travel_direction: Vector2, source: Node2D) -> void:
	global_position = spawn_position
	direction = travel_direction.normalized()
	rotation = direction.angle()
	shooter = source

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	lifetime_left -= delta
	if lifetime_left <= 0.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body == shooter:
		return

	if body.has_method("take_damage"):
		body.take_damage(damage)

	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area == shooter:
		return

	queue_free()
