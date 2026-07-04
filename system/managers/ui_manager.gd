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
	SignalBus.game_start.connect(new_game)


func update_plot_points(qty: int = 1) -> void:
	current_plot_points += qty
	
	SignalBus.plot_points_changed.emit(current_plot_points)
	
	if qty > 0:
		check_round_end()

func check_round_end() -> void:
	if current_plot_points >= current_chapter * plot_points_per_chapter:
		SignalBus.round_ended.emit()
		current_chapter += 1
		show_menu("news")
		SignalBus.chapter_ended.emit(current_chapter)

func show_menu(menu_name: StringName) -> void:
	if menu_registry[menu_name] == null:
		print("Menu not registered: %s" % menu_name)
		return
	
	if current_menu:
		current_menu.close()
	
	current_menu = menu_registry[menu_name]
	current_menu.open()

func quit_game() -> void:
	get_tree().quit()

func new_game() -> void:
	current_plot_points = 0
	current_chapter = 1
	SignalBus.plot_points_changed.emit(0)
	SignalBus.chapter_ended.emit(current_chapter)
	if current_menu != menu_registry["hud"]:
		show_menu("hud")
