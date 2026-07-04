extends Node2D
class_name MainRoom

@export_category("Node References")
@export var player: Player
@export var object_manager: ObjectManager
@export var ui_manager: UIManager

func _ready() -> void:
	SignalBus.game_start.connect(show)
	SignalBus.return_to_main_menu.connect(hide)

func start_game() -> void:
	show()

func quit_to_menu() -> void:
	hide()
