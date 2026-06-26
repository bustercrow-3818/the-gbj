extends Node
class_name State

signal change_state(next_state: StringName, _data: Dictionary)

var entity: Player

func initialize_state() -> void:
	
	pass

func enter_state(_data: Dictionary = {}) -> void:
	
	pass
	
func exit_state(_data: Dictionary = {}) -> void:
	
	pass
	
func state_process(_delta: float) -> void:
	
	pass

func state_physics(_delta: float) -> void:
	
	pass
