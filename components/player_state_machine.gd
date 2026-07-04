extends Node2D
class_name StateMachine

@export var move_stats: MovementStats
@export var jump_time: Timer
@export var stun_time: Timer

@onready var player: Player = get_parent()

var direction: float

func _ready() -> void:
	SignalBus.player_stun.connect(start_stun)
	SignalBus.round_ended.connect(_change_state.bind(states.PAUSED, "idle"))
	SignalBus.player_dead.connect(_change_state.bind(states.DEAD, "dead"))
	SignalBus.game_start.connect(_change_state.bind(states.IDLE, "idle"))
	SignalBus.player_ready.connect(_change_state.bind(states.IDLE, "idle"))
	SignalBus.game_pause.connect(_change_state.bind(states.PAUSED, "idle"))
	SignalBus.return_to_main_menu.connect(_change_state.bind(states.PAUSED, "idle"))
	SignalBus.news_stats_adjusted.connect(news_stats_change)

func _physics_process(_delta: float) -> void:
	direction = Input.get_axis("left", "right")
	
	match current_state:
		states.IDLE:
			idle()
		states.RUN:
			run()
		states.JUMP:
			jump()
		states.FALL:
			fall()
		states.DEAD:
			dead()
		states.STUNNED:
			stunned()
		states.PAUSED:
			paused()
		states.MENU_STASIS:
			paused()
		
	player.move_and_slide()

enum states{
	IDLE,
	RUN,
	JUMP,
	FALL,
	HIT,
	DEAD,
	STUNNED,
	PAUSED,
	MENU_STASIS
}

var current_state: states = states.IDLE

func _change_state(_new_state: states, _new_animation: StringName, _data: Dictionary = {}) -> void:
	current_state = _new_state
	player.sprite.play(_new_animation)

#region State Functions
func idle(_data: Dictionary = {}) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, move_stats.current_decel)
	
	if direction != 0:
		_change_state(states.RUN, "run")
	elif Input.is_action_just_pressed("jump"):
		player.velocity.x *= 0.5
		start_jump()
	elif player.is_on_floor() == false:
		await get_tree().create_timer(move_stats.coyote_time).timeout
		if not player.is_on_floor():
			move_stats.jumps_left -= 1
			_change_state(states.FALL, "fall")

func run(_data: Dictionary = {}) -> void:
	horizontal_motion(direction)
	
	if direction == 0:
		_change_state(states.IDLE, "idle")
	elif Input.is_action_just_pressed("jump"):
		start_jump()
	elif player.is_on_floor() == false:
		await get_tree().create_timer(move_stats.coyote_time).timeout
		if not player.is_on_floor():
			move_stats.jumps_left -= 1
			_change_state(states.FALL, "fall")

func jump(_data: Dictionary = {}) -> void:
	gravity()
	horizontal_motion(direction)
	
	if Input.is_action_just_released("jump") or player.is_on_ceiling() or jump_time.time_left == 0:
		if player.velocity.y < 0:
			player.velocity.y *= 0.5
		_change_state(states.FALL, "fall")
	elif Input.is_action_just_pressed("jump") and move_stats.jumps_left > 0:
		start_jump()

func fall(_data: Dictionary = {}) -> void:
	gravity()
	horizontal_motion(direction)
	
	if player.is_on_floor():
		move_stats.jumps_left = move_stats.current_max_jumps
		_change_state(states.IDLE, "idle")
	elif Input.is_action_just_pressed("jump") and move_stats.jumps_left > 0:
		start_jump()

func dead(_data: Dictionary = {}) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, move_stats.current_decel)
	gravity()

func stunned(_data: Dictionary = {}) -> void:
	gravity()
	pass

func paused() -> void:
	
	pass
#endregion

#region Helper Functions
func horizontal_motion(_dir: float) -> void:
	if _dir < 0:
		player.sprite.flip_h = true
	elif _dir > 0:
		player.sprite.flip_h = false
	
	if player.velocity.x != move_stats.current_speed_max * _dir:
		player.velocity.x = move_toward(player.velocity.x, move_stats.current_speed_max * _dir, move_stats.current_accel)

func gravity() -> void:
	if player.velocity.y < move_stats.current_terminal_velocity:
		player.velocity.y += move_stats.current_fall_speed

func start_stun(duration: float) -> void:
	var previous_state: states = current_state
	var previous_anim: StringName = player.sprite.animation
	var previous_velocity: Vector2 = player.velocity
	
	if previous_state == states.DEAD:
		previous_state = states.IDLE
		previous_anim = "idle"
	
	player.velocity = Vector2.ZERO
	_change_state(states.STUNNED, "fall")
	
	await get_tree().create_timer(duration).timeout
	if current_state in [states.DEAD, states.PAUSED]:
		pass
	else:
		player.velocity = previous_velocity
		_change_state(previous_state, previous_anim)

func start_jump() -> void:
	player.velocity.y *= 0.5
	player.velocity.y -= move_stats.current_jump_speed
	move_stats.jumps_left -= 1
	jump_time.start(move_stats.current_jump_time)
	_change_state(states.JUMP, "jump")

func enter_stasis() -> void:
	player.hide()
	_change_state(states.MENU_STASIS, "idle")
	
	pass
#endregion

func news_stats_change(stat: StringName, _data: Dictionary) -> void:
	match stat:
		"jump_speed":
			move_stats.current_jump_speed += _data["jump_speed"]
	pass
