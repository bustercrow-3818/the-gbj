extends State

func enter_state(_previous_state: String) -> void:
	sprite.play("dead")
	await sprite.animation_finished
	entity.die()
