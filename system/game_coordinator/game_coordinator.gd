extends Node

@export_category("Scene References")
@export var player_scene: PackedScene
@export var stage: PackedScene

@export_category("Node References")
@export var player: Player
@export var ui_manager: UIManager
@export var object_manager: ObjectManager

func _ready() -> void:
	
	pass

func start_new_game() -> void:
	if player == null:
		player = player_scene.instantiate()
	
	object_manager.reset_arena()
	pass
	
func return_to_main_menu() -> void:
	## Necessary functions sketch-out:
	## Hide/lock Player
	## Hide/lock/queue_free arena and clear all blocks and hazards if arena not freed
	## Reset scores and any adjustments to stats (MovementStats, PlotArmor) to initial values
	## Reset any hazard behavior changes
	
	
	
	pass
