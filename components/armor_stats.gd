extends Resource
class_name ArmorStats

@export var max_plot_armor: int = 10
var current_max_plot_armor: int = 10
var current_plot_armor: int = 0

func initialize() -> void:
	current_max_plot_armor = max_plot_armor
	current_plot_armor = 0

func adjust_plot_armor(amount: int) -> void: ## Adds amount to current_plot_armor, respecting upper bound of current_max_plot_armor and lower bound of zero. Will emit the new current_plot_armor value via SignalBus.plot_armor_changed and if current_plot_armor reaches zero, also emits SignalBus.player_dead. 
	current_plot_armor += amount
	
	if current_plot_armor > current_max_plot_armor:
		current_plot_armor = current_max_plot_armor
	
	if current_plot_armor < 0:
		current_plot_armor = 0
	
	SignalBus.plot_armor_changed.emit(current_plot_armor)
	
	if current_plot_armor == 0:
		SignalBus.player_dead.emit()
