extends Node2D
class_name MainRoom

func _ready() -> void:
	%player.coin_collected.connect(%object_manager.create_block)
