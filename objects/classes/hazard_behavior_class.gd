extends Resource
class_name HazardBehavior

@export var base_size: Vector2 = Vector2(1, 1)

func initialize_behavior() -> void:
	set_stats_to_default()

func process_effect(_delta: float) -> void:
	
	pass

func physics_effect(_delta: float) -> void:
	
	pass

func collision_effect(_body: Node2D) -> void:
	
	pass

func spawn_effect() -> void:
	
	pass

func set_stats_to_default() -> void:
	
	pass
