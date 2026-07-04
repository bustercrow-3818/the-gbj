extends MenuElement

func _ready() -> void:
	SignalBus.plot_points_changed.connect(update_final_score)
	%quit_button.pressed.connect(quit_to_main_menu)
	%restart_button.pressed.connect(restart_game)
	
func update_final_score(new_value: int) -> void:
	%final_score.text = str(new_value)

func restart_game() -> void:
	SignalBus.game_start.emit()
	menu_exited.emit("hud")

func quit_to_main_menu() -> void:
	menu_exited.emit("main_menu")
	SignalBus.return_to_main_menu.emit()
