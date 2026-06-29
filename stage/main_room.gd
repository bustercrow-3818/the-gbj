extends Node2D
class_name MainRoom

@export_category("Node References")
@export var player: Player
@export var object_manager: ObjectManager
@export var ui_manager: UIManager



func start_game() -> void:
	player.show()
	
	SignalBus.game_start.emit()
	pass
