extends Node2D

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
		
	player.move_and_slide()

enum states{
	IDLE,
	RUN,
	JUMP,
	FALL,
	HIT,
	DEAD,
	STUNNED,
	PAUSED
}

var current_state: states = states.IDLE

func _change_state(_new_state: states, _new_animation: StringName, _data: Dictionary = {}) -> void:
	print("changing state to %s" % states.find_key(_new_state))
	current_state = _new_state
	player.sprite.play(_new_animation)

#region State Functions
func idle(_data: Dictionary = {}) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, move_stats.run_decel)
	
	if direction != 0:
		_change_state(states.RUN, "run")
	elif Input.is_action_just_pressed("jump"):
		player.velocity.y -= move_stats.jump_speed
		player.velocity.x *= 0.5
		move_stats.jumps_left -= 1
		jump_time.start(move_stats.jump_time)
		_change_state(states.JUMP, "jump")
	elif player.is_on_floor() == false:
		await get_tree().create_timer(move_stats.coyote_time).timeout
		if not player.is_on_floor():
			_change_state(states.FALL, "fall")

func run(_data: Dictionary = {}) -> void:
	horizontal_motion(direction)
	
	if direction == 0:
		_change_state(states.IDLE, "idle")
	elif Input.is_action_just_pressed("jump"):
		player.velocity.y -= move_stats.jump_speed
		move_stats.jumps_left -= 1
		jump_time.start(move_stats.jump_time)
		_change_state(states.JUMP, "jump")
	elif player.is_on_floor() == false:
		await get_tree().create_timer(move_stats.coyote_time).timeout
		if not player.is_on_floor():
			_change_state(states.FALL, "fall")

func jump(_data: Dictionary = {}) -> void:
	gravity()
	horizontal_motion(direction)
	
	if Input.is_action_just_released("jump") or player.is_on_ceiling() or jump_time.time_left == 0:
		if player.velocity.y < 0:
			player.velocity.y *= 0.5
		_change_state(states.FALL, "fall")

func fall(_data: Dictionary = {}) -> void:
	gravity()
	horizontal_motion(direction)
	
	if player.is_on_floor():
		move_stats.jumps_left = move_stats.max_jumps
		_change_state(states.IDLE, "idle")
	elif move_stats.jumps_left > 0 and Input.is_action_just_released("jump"):
		player.velocity.y -= move_stats.jump_speed
		move_stats.jumps_left -= 1
		jump_time.start(move_stats.jump_time)
		_change_state(states.JUMP, "jump")

func dead(_data: Dictionary = {}) -> void:
	gravity()

func stunned(_data: Dictionary = {}) -> void:
	
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
	
	if player.velocity.x != move_stats.run_speed_max * _dir:
		player.velocity.x = move_toward(player.velocity.x, move_stats.run_speed_max * _dir, move_stats.run_accel)

func gravity() -> void:
	if player.velocity.y < move_stats.terminal_velocity:
		player.velocity.y += move_stats.fall_speed

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
	if current_state == states.PAUSED or current_state == states.DEAD:
		print("skipping state change because state is now %s" % states.find_key(current_state))
		pass
	else:
		print("returning to previous state")
		player.velocity = previous_velocity
		_change_state(previous_state, previous_anim)

	

#endregion
