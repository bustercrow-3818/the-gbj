extends MenuElement
class_name NewsMenu

func _ready() -> void:
	%good_news_first.pressed.connect(menu_exited.emit.bind("good_news"))
	%bad_news_first.pressed.connect(menu_exited.emit.bind("bad_news"))
