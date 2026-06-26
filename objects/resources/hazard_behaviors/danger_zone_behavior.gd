## Basic circular red hazard. Deals small damage when entered.
extends HazardBehavior
class_name DangerZoneBehavior

@export var base_damage: int = 1

var damage: int

func set_stats_to_default() -> void:
	damage = base_damage

func collision_effect(_body: Node2D) -> void:
	if _body is Player:
		_body.take_damage(damage)
