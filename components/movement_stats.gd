extends Resource
class_name MovementStats

@export_category("Run")
@export var run_accel: float = 25.0
@export var run_decel: float = 50.0
@export var run_speed_max: float = 300.0
var current_accel: float
var current_decel: float
var current_speed_max: float

@export_category("Jump")
@export var jump_speed: float = 500.0
@export var jump_time: float = 1.5
@export var max_jumps: int = 1
var current_jump_speed: float
var current_jump_time: float
var current_max_jumps: int
var jumps_left: int = 1

@export_category("Gravity")
@export var coyote_time: float = 0.5
@export var fall_speed: float = 50.0
@export var terminal_velocity: float = 1000.0
var current_fall_speed: float
var current_terminal_velocity: float

func initialize_values() -> void:
	current_accel = run_accel
	current_decel = run_decel
	current_speed_max = run_speed_max
	
	current_jump_speed = jump_speed
	current_max_jumps = max_jumps
	jumps_left = 1
	
	current_fall_speed = fall_speed
	current_terminal_velocity = terminal_velocity
