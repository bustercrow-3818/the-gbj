extends MenuElement

func _ready() -> void:
	SignalBus.plot_armor_changed.connect(update_plot_armor)
	SignalBus.plot_points_changed.connect(update_plot_points)

func update_plot_armor(value: int) -> void:
	%plot_armor.text = "Plot Armor: " + str(value)

func update_plot_points(value: int) -> void:
	%plot_points.text = "Plot Points: " + str(value)
