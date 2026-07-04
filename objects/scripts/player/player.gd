extends CharacterBody2D
class_name Player

@warning_ignore("unused_signal")
signal unzoom_finished

#region Export variables
@export_category("Stats")
@export var move_stats: MovementStats
@export var plot_armor: ArmorStats

@export_category("Node References")
@export var state_machine: StateMachine
@export var sprite: AnimatedSprite2D
@export var camera: Camera2D
@export var jump_time: Timer

@export_category("Juice Numbers")
@export var break_time_zoom: Vector2 = Vector2(4, 4)
@export var break_time_duration: float = 3.0
@export var respawn_slide_time: float = 0.1
#endregion

func _ready() -> void:
	SignalBus.round_ended.connect(break_time_start)
	SignalBus.game_resume.connect(break_time_end)
	SignalBus.coin_collected.connect(on_coin_collected)
	state_machine.move_stats = move_stats.duplicate()
	state_machine.move_stats.initialize_values()

func _process(_delta: float) -> void:
	%debug_msg.text = str(state_machine.states.find_key(state_machine.current_state))

func on_coin_collected() -> void:
	plot_armor.adjust_plot_armor(1)

func initialize_player(location: Vector2) -> void:
	var spawn_tween: Tween = create_tween()
	
	plot_armor.initialize()

	spawn_tween.tween_property(self, "global_position", location, respawn_slide_time)
	
	SignalBus.game_pause.emit()
	await spawn_tween.finished
	
	SignalBus.player_ready.emit()

#region VFX

func break_time_start() -> void:
	velocity = Vector2.ZERO
	await zoom_camera(Vector2(break_time_zoom), 0.25)

func break_time_end() -> void:
	await zoom_camera(Vector2(1, 1), break_time_duration)
	SignalBus.player_ready.emit()

func zoom_camera(zoom_level: Vector2 = Vector2(1.0, 1.0), duration: float = 0.0) -> void:
	var zoom_tween: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	zoom_tween.tween_property(camera, "zoom", zoom_level, duration)
	await zoom_tween.finished

#endregion

func stasis() -> void:
	hide()
	velocity = Vector2.ZERO
	pass
