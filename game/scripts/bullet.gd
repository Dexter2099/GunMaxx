extends Area2D

@export var speed: float = 800.0
@export var max_lifetime: float = 1.2

var direction: Vector2 = Vector2.RIGHT
var lifetime_left: float = 0.0

func _ready() -> void:
	lifetime_left = max_lifetime
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func setup(spawn_position: Vector2, travel_direction: Vector2) -> void:
	global_position = spawn_position
	direction = travel_direction.normalized()
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	lifetime_left -= delta
	if lifetime_left <= 0.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.has_method("die"):
		body.call("die")
	queue_free()

func _on_area_entered(_area: Area2D) -> void:
	queue_free()
