extends Area2D
class_name Hazard

@export var behavior: HazardBehavior

func _ready() -> void:
	body_entered.connect(collision_effect)

func spawn_effect() -> void:
	behavior.spawn_effect()

func collision_effect(body: Node2D) -> void:
	behavior.collision_effect(body)
