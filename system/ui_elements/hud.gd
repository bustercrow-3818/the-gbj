extends MenuElement

@export_category("String settings")
@export var plot_armor_prefix: String
@export var plot_armor_suffix: String
@export var plot_points_prefix: String

func _ready() -> void:
	SignalBus.plot_armor_changed.connect(update_plot_armor)
	SignalBus.plot_points_changed.connect(update_plot_points)
	SignalBus.max_plot_armor_changed.connect(max_plot_armor_changed)

func max_plot_armor_changed(new_max: int, current_value: int) -> void:
	plot_armor_suffix = " / " + str(new_max)
	update_plot_armor(current_value)

func update_plot_armor(value: int) -> void:
	%plot_armor.text = plot_armor_prefix + str(value) + plot_armor_suffix

func update_plot_points(value: int) -> void:
	%plot_points.text = plot_points_prefix + str(value)
