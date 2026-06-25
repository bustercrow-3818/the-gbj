extends NewsAlt

@export var plot_armor_bonus: int = 5

func pickup_effect() -> void:
	player.max_plot_armor += plot_armor_bonus
