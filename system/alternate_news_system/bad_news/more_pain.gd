extends NewsAlt

@export var hazard_damage_increase: int = 1

func pickup_effect() -> void:
	for i in get_tree().get_nodes_in_group("game objects"):
		if i is Killer:
			i.damage += hazard_damage_increase
