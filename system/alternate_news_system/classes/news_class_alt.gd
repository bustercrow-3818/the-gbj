extends Node
class_name NewsAlt

@export_multiline var button_text: String
@export_multiline var tooltip: String

var player: Player
var object_manager: ObjectManager

func _ready() -> void:
	initialize_news()

func initialize_news() -> void:
	player = get_tree().get_first_node_in_group("player")
	object_manager = get_tree().get_first_node_in_group("object manager")

func pickup_effect() -> void:
	
	pass

func removal_effect() -> void:
	
	pass

func process_effect(_delta: float) -> void:
	
	pass
	
func physics_effect(_delta: float) -> void:
	
	pass
