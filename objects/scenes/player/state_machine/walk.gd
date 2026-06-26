extends State

var accel: float
var decel: float
var max_move_speed: float

func initialize_state() -> void:
	accel = entity.move_stats.run_accel
	decel = entity.move_stats.run_decel
	max_move_speed = entity.move_stats.run_speed_max

func state_physics(_delta: float) -> void:
	entity.horizontal_motion()
	pass
