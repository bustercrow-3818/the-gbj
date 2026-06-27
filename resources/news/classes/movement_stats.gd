extends Resource
class_name MovementStats

@export_category("Run")
@export var run_accel: float = 25.0
@export var run_decel: float = 50.0
@export var run_speed_max: float = 300.0

@export_category("Jump")
@export var jump_speed: float = 500.0
@export var jump_time: float = 1.5
@export var max_jumps: int = 1
var jumps_left: int = 1

@export_category("Gravity")
@export var coyote_time: float = 0.5
@export var fall_speed: float = 50.0
@export var terminal_velocity: float = 1000.0
