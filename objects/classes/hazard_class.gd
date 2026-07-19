extends Area2D
class_name Hazard

@export var behavior: HazardBehavior
@export var spawn_effect_timer: float = 0.5

func _ready() -> void:
	body_entered.connect(collision_effect)
	
	var scale_tween: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	scale_tween.tween_property(self, "scale", Vector2(1, 1), spawn_effect_timer)

func spawn_effect() -> void:
	behavior.spawn_effect()

func collision_effect(body: Node2D) -> void:
	behavior.collision_effect(body)
