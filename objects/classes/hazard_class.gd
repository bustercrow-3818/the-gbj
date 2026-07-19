extends Area2D
class_name Hazard

@export var behavior: HazardBehavior
@export var spawn_effect_timer: float = 0.5

func _ready() -> void:
	scale = behavior.base_size * 2
	
	await resize()
	body_entered.connect(collision_effect)

func spawn_effect() -> void:
	behavior.spawn_effect()

func collision_effect(body: Node2D) -> void:
	behavior.collision_effect(body)

func resize() -> void:
	var scale_tween: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "scale", behavior.base_size, spawn_effect_timer)
	
	await scale_tween.finished
