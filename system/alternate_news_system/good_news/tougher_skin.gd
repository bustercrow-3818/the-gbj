extends NewsAlt

@export var plot_armor_bonus: int = 5

func pickup_effect() -> void:
	player.plot_armor.current_max_plot_armor += plot_armor_bonus
	SignalBus.max_plot_armor_changed.emit(player.plot_armor.current_max_plot_armor, player.plot_armor.current_plot_armor)
