extends Area2D
class_name Killer

@export var damage: int = 3
@export var recoil: float = 0.25

func _ready() -> void:
	body_entered.connect(deal_damage)

func deal_damage(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
		body.velocity *= -recoil
