extends CanvasLayer
class_name UIManager

@export var plot_points_per_chapter: int = 10

@export_category("Node References")
@export var good_news_choices: Control
@export var bad_news_choices: Control

var current_plot_points: int = 0
var current_chapter: int = 1

var need_good_news: bool = true
var need_bad_news: bool = true

var menu_registry: Dictionary[StringName, MenuElement]
var current_menu: MenuElement

func _ready() -> void:
	for menu in get_children():
		if menu is MenuElement:
			menu_registry[menu.name] = menu
			menu.menu_exited.connect(show_menu)
		
	#for button in good_news_choices.get_children():
		#if button is Button:
			#button.pressed.connect(good_news_selected)
	
	#for button in bad_news_choices.get_children():
		#if button is Button:
			#button.pressed.connect(bad_news_selected)
			
	connect_signals()

func connect_signals() -> void:
	SignalBus.coin_collected.connect(update_plot_points)
	SignalBus.player_dead.connect(show_menu.bind("game_over"))
	#SignalBus.player_damaged.connect(update_plot_armor)
	#SignalBus.plot_armor_changed.connect(update_plot_armor)
	#%quit_button.pressed.connect(quit_game)
	#%restart_button.pressed.connect(restart_game)
	#%good_news_first.pressed.connect(show_menu.bind("good_news"))
	#%bad_news_first.pressed.connect(show_menu.bind("bad_news"))

#func update_plot_armor(value: int) -> void:
	#%plot_armor.text = "Plot Armor: " + str(value)

func update_plot_points(qty: int = 1) -> void:
	current_plot_points += qty
	
	SignalBus.plot_points_changed.emit(current_plot_points)
	
	#%plot_points.text = "Plot Points: " + str(current_plot_points)
	
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

#func good_news_selected() -> void:
	#need_good_news = false
	#
	#if need_bad_news == true:
		#show_menu("bad_news")
	#else:
		#need_good_news = true
		#need_bad_news = true
		#show_menu("hud")
		#SignalBus.game_resume.emit()

#func bad_news_selected() -> void:
	#need_bad_news = false
	#
	#if need_good_news == true:
		#show_menu("good_news")
	#else:
		#need_good_news = true
		#need_bad_news = true
		#show_menu("hud")
		#SignalBus.game_resume.emit()

func restart_game() -> void:
	update_plot_points(-current_plot_points)
	
	show_menu("hud")
	SignalBus.game_start.emit()

func quit_game() -> void:
	get_tree().quit()

func new_game() -> void:
	
	pass
