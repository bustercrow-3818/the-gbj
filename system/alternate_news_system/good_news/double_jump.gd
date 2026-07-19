extends NewsAlt

func pickup_effect() -> void:
	player.move_stats.current_max_jumps += 1
