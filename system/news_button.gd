extends Button
class_name GoodNewsButton

@export var pool: NewsPool

var news: NewsAlt
var player: Player
var current_behavior: HazardBehavior

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	SignalBus.round_ended.connect(randomly_assign_news)

func randomly_assign_news() -> void:
	if news != null:
		news.queue_free()
	news = pool.news.pick_random().instantiate()
	add_child(news)
	news.initialize_news()
	set_button_text()

func set_button_text() -> void:
	text = news.button_text
	tooltip_text = news.tooltip

func _pressed() -> void:
	news.pickup_effect()

func set_hazard_reference(behavior: HazardBehavior) -> void:
	current_behavior = behavior
