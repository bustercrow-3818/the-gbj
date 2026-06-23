extends CharacterBody2D
class_name Player

signal coin_collected

var direction: float = 0.0
var game_paused: bool = false

@export_category("Stats")
@export var move_stats: MovementStats
var current_jump_height: float = 0
var terminal_velocity: float = 1000.0

@export_category("Other Stats")
@export var max_plot_armor: int = 10

@export_category("Node References")
@export var sprite: AnimatedSprite2D
@export var hud: HUD

@export_category("Juice Numbers")
@export var break_time_zoom: Vector2 = Vector2(4, 4)
@export var break_time_duration: float = 3.0
@export var respawn_slide_time: float = 0.1

func _ready() -> void:
	SignalBus.game_pause.connect(break_time_toggle)
	SignalBus.game_resume.connect(break_time_toggle)
	SignalBus.player_stun.connect(stun)

func _physics_process(_delta: float) -> void:
	direction = Input.get_axis("left", "right")
	
	if game_paused == true:
		pass
	else:
		match current_state:
			states.IDLE:
				idle()
			states.RUN:
				run()
			states.JUMP:
				jump()
			states.FALL:
				fall()
			states.HIT:
				hit()
			states.DEAD:
				dead()
			states.COYOTE:
				coyote_time_delay()
		
		move_and_slide()

#region State Machine

enum states{
	IDLE,
	RUN,
	JUMP,
	FALL,
	HIT,
	DEAD,
	COYOTE
}

var current_state: states = states.IDLE

func _change_state(_new_state: states, _new_animation: StringName, _data: Dictionary = {}) -> void:
	current_state = _new_state
	sprite.play(_new_animation)

func idle(_data: Dictionary = {}) -> void:
	velocity.x = move_toward(velocity.x, 0, move_stats.run_decel)
	
	if direction != 0:
		_change_state(states.RUN, "run")
	elif Input.is_action_just_pressed("jump"):
		velocity.y -= move_stats.jump_speed
		_change_state(states.JUMP, "jump")
	elif is_on_floor() == false:
		_change_state(states.COYOTE, "idle")

func run(_data: Dictionary = {}) -> void:
	horizontal_motion()
	
	if direction == 0:
		_change_state(states.IDLE, "idle")
	elif is_on_floor() == false:
		_change_state(states.COYOTE, "run")
	elif Input.is_action_just_pressed("jump"):
		velocity.y -= move_stats.jump_speed
		_change_state(states.JUMP, "jump")
	
	
func jump(_data: Dictionary = {}) -> void:
	current_jump_height = move_toward(current_jump_height, move_stats.jump_height_max, move_stats.jump_speed)
	horizontal_motion()
	
	if current_jump_height == move_stats.jump_height_max or Input.is_action_just_released("jump") or is_on_ceiling():
		current_jump_height = 0
		_change_state(states.FALL, "fall")

func fall(_data: Dictionary = {}) -> void:
	horizontal_motion()
	
	if velocity.y < terminal_velocity:
		velocity.y += move_stats.fall_speed
		
	if is_on_floor():
		current_jump_height = 0
		_change_state(states.IDLE, "idle")
	
func hit(_data: Dictionary = {}) -> void:
	
	pass

func dead(_data: Dictionary = {}) -> void:
	if velocity.y < terminal_velocity:
		velocity.y += move_stats.fall_speed

func coyote_time_delay(_data: Dictionary = {}) -> void:
	horizontal_motion()
	
	if Input.is_action_just_pressed("jump"):
		velocity.y -= move_stats.jump_speed
		_change_state(states.JUMP, "jump")
	elif current_state != states.DEAD:
		await get_tree().create_timer(move_stats.coyote_time).timeout
		_change_state(states.FALL, "fall")

func horizontal_motion() -> void:
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false
	
	if velocity.x != move_stats.run_speed_max * direction:
		velocity.x = move_toward(velocity.x, move_stats.run_speed_max * direction, move_stats.run_accel)



#endregion

func collect_coin() -> void:
	hud.update_plot_points()
	hud.update_plot_armor()
	coin_collected.emit()

func take_damage(amount: int) -> void:
	if hud.current_plot_armor == 0:
		velocity.x = 0
		_change_state(states.DEAD, "dead")
		SignalBus.player_dead.emit()
	
	hud.update_plot_armor(-amount)

func initialize_player(location: Vector2) -> void:
	var spawn_tween: Tween = create_tween()
	
	spawn_tween.tween_property(self, "global_position", location, respawn_slide_time)
	_change_state(states.IDLE, "idle")
	game_pause_resume()
	await spawn_tween.finished
	game_pause_resume()

func game_pause_resume() -> void:
	game_paused = !game_paused

func break_time_toggle() -> void:
	if game_paused == false:
		await zoom_camera(break_time_zoom, 0.25)
		
	else:
		velocity = Vector2.ZERO
		await zoom_camera(Vector2(1, 1), break_time_duration)
	
	game_pause_resume()

func stun(duration: float = 0.0) -> void:
	game_pause_resume()
	await get_tree().create_timer(duration).timeout
	game_pause_resume()

func zoom_camera(zoom_level: Vector2 = Vector2(1.0, 1.0), duration: float = 0.0) -> void:
	var zoom_tween: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	zoom_tween.tween_property(%camera, "zoom", zoom_level, duration)
	await zoom_tween.finished
