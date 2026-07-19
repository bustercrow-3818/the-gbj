extends Button
class_name GoodNewsButton

@export var pool: NewsPool
@export var themes: Array[Theme]
@export var max_rotation_degrees: float = 180

var news: NewsAlt
var player: Player
var current_behavior: HazardBehavior

func _ready() -> void:
	pivot_offset = size / 2
	player = get_tree().get_first_node_in_group("player")
	SignalBus.round_ended.connect(randomly_assign_news)

func randomly_assign_news() -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	if news != null:
		news.queue_free()
	
	set_visual_variety()
	
	news = pool.news.pick_random().instantiate()
	add_child(news)
	news.initialize_news()
	set_button_text()

func set_button_text() -> void:
	text = news.button_text
	tooltip_text = news.tooltip

func _pressed() -> void:
	news.reparent(player)
	news.pickup_effect()
	news = null

func set_hazard_reference(behavior: HazardBehavior) -> void:
	current_behavior = behavior

func set_visual_variety() -> void:
	theme = themes.pick_random()
	rotation_degrees += randf_range(-max_rotation_degrees, max_rotation_degrees)
