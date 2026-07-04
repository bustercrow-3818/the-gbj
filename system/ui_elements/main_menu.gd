extends MenuElement

@export var play_game: Button
@export var settigns: Button
@export var exit: Button

func _ready() -> void:
	play_game.pressed.connect(new_game)
	exit.pressed.connect(get_tree().quit)
	pass
	
func new_game() -> void:
	menu_exited.emit("hud")
	SignalBus.game_start.emit()
