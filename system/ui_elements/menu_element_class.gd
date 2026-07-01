extends Control
class_name MenuElement

@warning_ignore("unused_signal")
signal menu_exited(new_menu: StringName)

@export var initial_focus: Control

func open() -> void: ## Process executed when the menu is opened. Implement additional behavior alongside super() to maintain intended function.
	show()
	process_mode = Node.PROCESS_MODE_INHERIT
	if initial_focus is Control:
		initial_focus.grab_focus()
	
func close() -> void: ## Process executed when the menu is closed. Implement additional behavior alongside super() to maintain intended function.
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	if initial_focus is Control:
		initial_focus.release_focus()
	
func initialize() -> void:
	
	pass
