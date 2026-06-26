extends State

func enter_state(_previous_state: String) -> void:
	if sprite.current_animation == "hit":
		sprite.stop()
		
	sprite.play("hit")
	
func physics_action(_delta: float) -> void:
	if entity.health.current_hp < 1:
		change_state.emit("dead")
		disconnect("change_state", get_parent().change_state)
	else:
		await sprite.animation_finished
		change_state.emit("idle")
