extends CanvasLayer
class_name HUD

@export var plot_points_per_chapter: int = 10

var current_plot_armor: int = 0
var current_plot_points: int = 0
var current_chapter: int = 1

var need_good_news: bool = true
var need_bad_news: bool = true

func _ready() -> void:
	SignalBus.player_dead.connect(show_game_over)
	%quit_button.pressed.connect(quit_game)
	%restart_button.pressed.connect(restart_game)
	
	%good_news_first.pressed.connect(show_good_news)
	%bad_news_first.pressed.connect(show_bad_news)
	
	for button in %good_news_choices.get_children():
		if button is Button:
			button.pressed.connect(good_news_selected)
	
	for button in %bad_news_choices.get_children():
		if button is Button:
			button.pressed.connect(bad_news_selected)
	
func _process(_delta: float) -> void:
	%timer_bar.value = %game_timer.time_left



func update_plot_armor(qty: int = 1) -> void:
	current_plot_armor += qty
	
	if current_plot_armor < 0:
		current_plot_armor = 0
	
	%plot_armor.text = "Plot Armor: " + str(current_plot_armor)

func update_plot_points(qty: int = 1) -> void:
	current_plot_points += qty
	%plot_points.text = "Plot Points: " + str(current_plot_points)
	
	if current_plot_points >= current_chapter * plot_points_per_chapter:
		current_chapter += 1
		show_news()



func hide_all_interface() -> void:
	for i in get_children():
		i.hide()

func show_game_over() -> void:
	hide_all_interface()

	%final_score.text = str(current_plot_points)
	%game_over.show()

func show_game_display() -> void:
	hide_all_interface()
	%game_display.show()
	%timer.show()

func show_news() -> void:
	hide_all_interface()
	%news.show()

func show_good_news() -> void:
	hide_all_interface()
	%good_news.show()
	need_good_news = false

func show_bad_news() -> void:
	hide_all_interface()
	%bad_news.show()
	need_bad_news = false

func good_news_selected() -> void:
	if need_bad_news == true:
		show_bad_news()
	else:
		need_good_news = true
		need_bad_news = true
		show_game_display()

func bad_news_selected() -> void:
	if need_good_news == true:
		show_good_news()
	else:
		need_good_news = true
		need_bad_news = true
		show_game_display()



func restart_game() -> void:
	%timer_bar.max_value = %game_timer.wait_time
	%timer_bar.value = 0
	update_plot_armor(-current_plot_armor)
	update_plot_points(-current_plot_points)
	
	show_game_display()
	SignalBus.game_start.emit()

func quit_game() -> void:
	get_tree().quit()
