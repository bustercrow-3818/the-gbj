extends Button
class_name GoodNewsButton

@export var pool: NewsPool

var news: GoodNews

func randomly_assign_news() -> void:
	news = pool.news.pick_random()
	set_button_text()

func set_button_text() -> void:
	text = news.button_text
	tooltip_text = news.tooltip
