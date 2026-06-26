extends State

func enter_state(_previous_state: String) -> void:
	entity.velocity.y = 0
	entity.velocity.y -= entity.movement.jump_speed
	entity.movement.remaining_jumps -= 1
	entity.direction.y = 0
	sprite.play("jump")
	
func physics_action(_delta: float) -> void:
	
	change_state.emit("fall")
