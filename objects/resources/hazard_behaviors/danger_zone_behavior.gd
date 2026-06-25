## Basic circular red hazard. Deals small damage when entered.
extends HazardBehavior
class_name DangerZoneBehavior

@export var base_damage: int = 1

var damage: int

func set_stats_to_default() -> void:
	damage = base_damage

func collision_effect(_body: Node2D) -> void:
	print("hazard behavior effect")
	if _body is Player:
		print("found player. dealing %s damage" % str(damage))
		_body.take_damage(damage)
