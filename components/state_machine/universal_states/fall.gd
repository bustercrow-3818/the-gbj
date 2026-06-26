extends State

func enter_state(_previous_state: String) -> void:
	if _previous_state == "idle" or _previous_state == "walk":
		entity.movement.remaining_jumps -= 1
	sprite.play("jump")

func physics_action(_delta: float) -> void:
	horizontal_motion_processing()
	
	if entity.is_on_floor():
		change_state.emit("idle")
	elif entity.movement.remaining_jumps > 0 and entity.direction.y < 0:
		change_state.emit("jump")
