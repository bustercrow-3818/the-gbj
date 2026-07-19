extends NewsAlt

@export var minimum_scale: Vector2 = Vector2(0.125, 0.125)

func pickup_effect() -> void:
	var info: Dictionary = {}
	
	SignalBus.info_request.emit("current_behavior", info)
	
	var behavior: HazardBehavior = info["current_behavior"]
	
	if behavior.base_size > minimum_scale:
		behavior.base_size *= 0.5
	
	for i in get_tree().get_nodes_in_group("hazards"):
		var current: Hazard = i
		current.resize()
