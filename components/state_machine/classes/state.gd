extends Node2D
class_name State

@warning_ignore("unused_signal")
signal change_state(next_state: StringName)

var entity: Player
var sprite: AnimationPlayer
var direction: float

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	
	pass

func enter_state(_previous_state: String) -> void:
	
	pass
	
func exit_state() -> void:
	
	pass
	
func process_action(_delta: float) -> void:
	
	pass
	
func physics_action(_delta: float) -> void:
	
	pass

func horizontal_motion_processing() -> void:
	entity.horizontal_motion(direction)

func get_player_direction_input() -> float:
	return Input.get_axis("left", "right")
