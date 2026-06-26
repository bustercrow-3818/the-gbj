extends NewsAlt

@export var hazard_damage_increase: int = 1

func pickup_effect() -> void:
	var info: Dictionary = {}
	
	SignalBus.info_request.emit("current_hazard_behavior", info)
	
	var behavior: HazardBehavior = info["current_hazard_behavior"]
	
	if behavior.base_damage:
		behavior.damage += hazard_damage_increase
