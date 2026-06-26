extends Node2D
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary[StringName, State]
var entity: Player

func initialize() -> void:
	if owner is Player:
		entity = owner
	
	if get_children().is_empty():
		pass
	else:
		for i in get_children():
			if i is State:
				i.entity = entity
				i.sprite = entity.sprite
				if i.change_state.is_connected(change_state):
					pass
				else:
					i.change_state.connect(change_state)
				states[i.name.to_lower()] = i
			
		current_state = initial_state

func _physics_process(delta: float) -> void:
	if current_state == null:
		pass
	else:
		current_state.physics_action(delta)

func _process(delta: float) -> void:
	if current_state == null:
		pass
	else:
		current_state.process_action(delta)

func change_state(next_state: StringName) -> void:
	if current_state == states["dead"]:
		pass
	elif next_state in states:
		states[next_state].enter_state(current_state.name)
		current_state = states[next_state]
	else:
		print("Tried to transition to missing state'%s'" % next_state)
