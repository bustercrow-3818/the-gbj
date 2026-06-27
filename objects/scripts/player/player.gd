extends CharacterBody2D
class_name Player

@warning_ignore("unused_signal")
signal unzoom_finished

var direction: float = 0.0
var game_paused: bool = false
var stunned: bool = false

#region Export variables
@export_category("Stats")
@export var move_stats: MovementStats
@export var max_plot_armor: int = 10
var current_max_plot_armor: int = 10
var current_plot_armor: int = 0

@export_category("Node References")
@export var sprite: AnimatedSprite2D
@export var hud: HUD
@export var camera: Camera2D
@export var jump_time: Timer

@export_category("Juice Numbers")
@export var break_time_zoom: Vector2 = Vector2(4, 4)
@export var break_time_duration: float = 3.0
@export var respawn_slide_time: float = 0.1
#endregion

func _ready() -> void:
	SignalBus.round_ended.connect(break_time_toggle)
	SignalBus.game_resume.connect(break_time_toggle)
	#SignalBus.player_stun.connect(stun)
	SignalBus.coin_collected.connect(on_coin_collected)

func take_damage(amount: int) -> void:
	current_plot_armor -= amount
	
	if current_plot_armor == 0:
		velocity.x = 0
		SignalBus.player_dead.emit()
	
	SignalBus.player_damaged.emit(-amount)

func on_coin_collected() -> void:
	if current_plot_armor < current_max_plot_armor:
		current_plot_armor += 1

func initialize_player(location: Vector2) -> void:
	var spawn_tween: Tween = create_tween()
	
	current_plot_armor = 0
	current_max_plot_armor = max_plot_armor
	spawn_tween.tween_property(self, "global_position", location, respawn_slide_time)
	
	game_pause_resume()
	await spawn_tween.finished
	
	game_pause_resume()

#region VFX
func game_pause_resume() -> void:
	game_paused = !game_paused

func break_time_start() -> void:
	
	pass

func break_time_toggle() -> void:
	var zoom: Vector2
	var duration: float
	
	if game_paused == false:
		zoom = break_time_zoom
		duration = 0.25
		
	else:
		velocity = Vector2.ZERO
		zoom = Vector2(1, 1)
		duration = break_time_duration
	
	game_pause_resume()
	zoom_camera(zoom, duration)

#func stun(duration: float = 0.0) -> void:
	#stunned = true
	#await get_tree().create_timer(duration).timeout
	#stunned = false

func zoom_camera(zoom_level: Vector2 = Vector2(1.0, 1.0), duration: float = 0.0) -> void:
	var zoom_tween: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	zoom_tween.tween_property(camera, "zoom", zoom_level, duration)
	await zoom_tween.finished


#endregion

func info_request(_request_name: StringName, _info: Dictionary) -> void:
	
	pass
