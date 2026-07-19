extends NewsAlt

func pickup_effect() -> void:
	var info: Dictionary = {}
	
	SignalBus.info_request.emit("current_behavior", info)
	
	var behavior: HazardBehavior = info["current_behavior"]
	
	behavior.base_size += Vector2(0.25, 0.25)
	
	for i in get_tree().get_nodes_in_group("hazards"):
		var current: Hazard = i
		current.resize()
