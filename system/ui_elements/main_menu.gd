extends Control

@export_category("Node References")
@export var play_game: Button
@export var settings: Button
@export var exit_game: Button

func _ready() -> void:
	exit_game.pressed.connect(get_tree().quit)
	
