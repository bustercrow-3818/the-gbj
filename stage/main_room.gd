extends Node2D
class_name MainRoom

@export var player: Player

func _ready() -> void:
	player.coin_collected.connect(%object_manager.create_block)
	
