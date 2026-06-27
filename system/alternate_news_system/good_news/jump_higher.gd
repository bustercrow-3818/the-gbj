extends NewsAlt

@export var jump_speed_bonus: float = 32

func pickup_effect() -> void:
	player.move_stats.jump_speed += jump_speed_bonus

func removal_effect() -> void:
	player.move_stats.jump_speed -= jump_speed_bonus
