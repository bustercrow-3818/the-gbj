extends CharacterBody2D
class_name Player

signal coin_collected

var direction: float = 0.0

@export_category("Stats")
@export var run_accel: float = 25.0
@export var run_decel: float = 50.0
@export var run_speed_max: float = 300.0
var current_jump_height: float = 0
@export var jump_speed: float = 500.0
@export var jump_height_max: float = 5000.0
var terminal_velocity: float = 1000.0
@export var coyote_time: float = 0.5
@export var fall_speed: float = 50.0

@export_category("Node References")
@export var sprite: AnimatedSprite2D
@export var hud: HUD

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
	velocity.x = move_toward(velocity.x, 0, run_decel)
	
	if direction != 0:
		_change_state(states.RUN, "run")
	elif Input.is_action_just_pressed("jump"):
		velocity.y -= jump_speed
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
		velocity.y -= jump_speed
		_change_state(states.JUMP, "jump")
	
	
func jump(_data: Dictionary = {}) -> void:
	current_jump_height = move_toward(current_jump_height, jump_height_max, jump_speed)
	horizontal_motion()
	
	if current_jump_height == jump_height_max or Input.is_action_just_released("jump") or is_on_ceiling():
		current_jump_height = 0
		_change_state(states.FALL, "fall")

func fall(_data: Dictionary = {}) -> void:
	horizontal_motion()
	
	if velocity.y < terminal_velocity:
		velocity.y += fall_speed
		
	if is_on_floor():
		current_jump_height = 0
		_change_state(states.IDLE, "idle")
	
func hit(_data: Dictionary = {}) -> void:
	
	pass

func dead(_data: Dictionary = {}) -> void:
	if velocity.y < terminal_velocity:
		velocity.y += fall_speed

func coyote_time_delay(_data: Dictionary = {}) -> void:
	horizontal_motion()
	
	if Input.is_action_just_pressed("jump"):
		velocity.y -= jump_speed
		_change_state(states.JUMP, "jump")
	elif current_state != states.DEAD:
		await get_tree().create_timer(coyote_time).timeout
		_change_state(states.FALL, "fall")

func horizontal_motion() -> void:
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false
	
	if velocity.x != run_speed_max * direction:
		velocity.x = move_toward(velocity.x, run_speed_max * direction, run_accel)



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
	global_position = location
	_change_state(states.IDLE, "idle")
