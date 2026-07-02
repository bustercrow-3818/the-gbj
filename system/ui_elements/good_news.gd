extends MenuElement

var last_news: bool = false

func _ready() -> void:
	SignalBus.bad_news_chosen.connect(bad_news_chosen_first)
	
	for i in get_tree().get_nodes_in_group("good_news"):
		if i is GoodNewsButton:
			i.pressed.connect(news_complete_check)
	
func bad_news_chosen_first() -> void:
	last_news = true

func news_complete_check() -> void:
	if last_news == true:
		menu_exited.emit("hud")
		SignalBus.game_resume.emit()
	
	else:
		SignalBus.good_news_chosen.emit()
		menu_exited.emit("bad_news")
	
	last_news = false
