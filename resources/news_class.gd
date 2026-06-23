extends Resource
class_name News

var player: Player

@export_category("Stats")
@export var move_speed_adjustment: float = 0
@export var move_accel_adjustment: float = 0
@export var move_decel_adjustment: float = 0
@export var jump_height_adjustment: float = 0


@export_category("UI Information")
@export_multiline var button_text: String = "<placeholder>"
@export_multiline var tooltip: String = "<placeholder>"

func initialize_news(_player_node: Player, _data: Dictionary = {}) -> void:
	player = _player_node
	connect_signals()
	on_pickup_effect()
	
func connect_signals() -> void:
	
	pass

func physics_check(_delta: float) -> void:
	
	pass

func process_check(_delta: float) -> void:
	
	pass

func on_pickup_effect() -> void:
	
	pass

func on_remove_effect() -> void:
	
	pass

func get_button_text() -> String:
	return button_text

func get_tooltip() -> String:
	return tooltip
