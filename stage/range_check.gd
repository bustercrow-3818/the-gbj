extends ShapeCast2D
class_name RangeCheck

@export var check_range: float = 128
@export var max_spot_check_attempts: int = 5
@export var directions_to_check: int = 16

func get_random_point_from_source(source: Node2D) -> Vector2:
	global_position = source.global_position
	set_non_collision_target()

	return to_global(target_position)

func set_non_collision_target() -> bool:
	var directions: Array[Vector2]
	var initial_direction: Vector2 = Vector2.from_angle(randf() * (2*PI)) * randf_range(check_range/2, 2*check_range)
	var is_check_good: bool = false
	
	var current_attempt: int = 0
	
	for i in directions_to_check:
		directions.append(Vector2.from_angle((PI / (float(directions_to_check) / 2)) * i))
	
	target_position = initial_direction
	
	force_shapecast_update()
	
	for direction in directions:
		current_attempt += 1
		force_shapecast_update()
		print("is_colliding check = %s" % str(is_colliding()))
		if is_colliding():
			print("--------------------")
			print("---- Attemp # %s ----" % str(current_attempt))
			print("tested target %s" % str(target_position))
			print("trying again with direction %s" % str(direction))
			
			target_position = direction * initial_direction
			print ("new target position is %s" % str(target_position))
			print("--------------------")
				
		else:
			force_shapecast_update()
			print("--------------------")
			print("---- Attempt # %s ----" % str(current_attempt))
			print("good position found at %s" % str(target_position))
			print("--------------------")
			is_check_good = true
	
	return is_check_good
