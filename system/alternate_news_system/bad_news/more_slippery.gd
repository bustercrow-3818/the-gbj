extends NewsAlt

@export var friction_coefficient: float = 0.5
@export var minimum_accel_decel: float = 5

var old_decel: float
var old_accel: float

func pickup_effect() -> void:
	old_decel = player.move_stats.run_decel
	old_accel = player.move_stats.run_accel
	
	player.move_stats.run_decel = max(friction_coefficient * player.move_stats.run_decel, minimum_accel_decel)
	player.move_stats.run_accel = max(friction_coefficient * player.move_stats.run_accel, minimum_accel_decel)

func removal_effect() -> void:
	player.move_stats.run_accel = old_accel
	player.move_stats.run_decel = old_decel
