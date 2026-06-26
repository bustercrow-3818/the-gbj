extends State

func enter_state(_previous_state: String) -> void:
	entity.movement.reset_jump_counter()
	sprite.play("walk")

func physics_action(_delta: float) -> void:
	horizontal_motion_processing()

	if entity.is_on_floor() and entity.direction.x == 0:
		change_state.emit("idle")
	elif not entity.is_on_floor():
		await get_tree().create_timer(GlobalValues.coyote_time).timeout
		change_state.emit("fall")
	elif entity.direction.y == -1:
		change_state.emit("jump")
