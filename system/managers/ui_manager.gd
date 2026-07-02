extends CanvasLayer
class_name UIManager

@export var plot_points_per_chapter: int = 10

@export_category("Node References")
@export var good_news_choices: Control
@export var bad_news_choices: Control

var current_plot_points: int = 0
var current_chapter: int = 1

var menu_registry: Dictionary[StringName, MenuElement]
var current_menu: MenuElement

func _ready() -> void:
	for menu in get_children():
		if menu is MenuElement:
			menu_registry[menu.name] = menu
			menu.menu_exited.connect(show_menu)
			
	connect_signals()

func connect_signals() -> void:
	SignalBus.coin_collected.connect(update_plot_points)
	SignalBus.player_dead.connect(show_menu.bind("game_over"))


func update_plot_points(qty: int = 1) -> void:
	current_plot_points += qty
	
	SignalBus.plot_points_changed.emit(current_plot_points)
	
	if current_plot_points >= current_chapter * plot_points_per_chapter:
		SignalBus.round_ended.emit()
		current_chapter += 1
		show_menu("news")

func show_menu(menu_name: StringName) -> void:
	if menu_registry[menu_name] == null:
		print("Menu not registered: %s" % menu_name)
		return
	
	if current_menu:
		current_menu.close()
	
	current_menu = menu_registry[menu_name]
	current_menu.open()

func check_news_progress() -> void:
	
	pass

func restart_game() -> void:
	update_plot_points(-current_plot_points)
	
	show_menu("hud")
	SignalBus.game_start.emit()

func quit_game() -> void:
	get_tree().quit()

func new_game() -> void:
	
	pass
