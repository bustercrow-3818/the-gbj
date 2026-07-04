extends NewsAlt

@export var jump_speed_bonus: float = 32

func pickup_effect() -> void:
	var _data: Dictionary = {
		"jump_speed" : jump_speed_bonus
	}
	SignalBus.news_stats_adjusted.emit("jump_speed", _data)
	#player.move_stats.jump_speed += jump_speed_bonus

func removal_effect() -> void:
	player.move_stats.jump_speed -= jump_speed_bonus
