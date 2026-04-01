extends Area2D

signal collected

@export var heal_amount: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	if not body.has_method("heal"):
		return

	body.heal(heal_amount)
	collected.emit()
	queue_free()
