extends MenuElement

func _ready() -> void:
	SignalBus.plot_points_changed.connect(update_final_score)
	
func update_final_score(new_value: int) -> void:
	%final_score.text = "Final score: " + str(new_value)
