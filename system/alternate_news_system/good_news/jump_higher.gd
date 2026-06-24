extends NewsAlt

@export var jump_height_bonus: float = 32
@export var jump_height_multiplier: float = 1.0

func pickup_effect() -> void:
	print("changing %s" % str(player.move_stats.jump_height_max))
	player.move_stats.jump_height_max += jump_height_bonus
	player.move_stats.jump_height_max *= jump_height_multiplier
	print("changed it to %s" % str(player.move_stats.jump_height_max))
	

func removal_effect() -> void:
	player.move_stats.jump_height_max -= jump_height_bonus
