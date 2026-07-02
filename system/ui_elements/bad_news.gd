extends MenuElement

var last_news: bool = false

func _ready() -> void:
	SignalBus.good_news_chosen.connect(good_news_chosen_first)
	
	for i in get_tree().get_nodes_in_group("bad_news"):
		if i is GoodNewsButton:
			i.pressed.connect(news_complete_check)
	
func good_news_chosen_first() -> void:
	last_news = true

func news_complete_check() -> void:
	if last_news == true:
		print("should be returning to game")
		menu_exited.emit("hud")
		SignalBus.game_resume.emit()
	
	else:
		print("should be moving to good news")
		SignalBus.bad_news_chosen.emit()
		menu_exited.emit("good_news")
		
	last_news = false
