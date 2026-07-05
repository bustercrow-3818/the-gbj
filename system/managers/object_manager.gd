extends Node2D
class_name ObjectManager

#region Export Variables
@export_category("Scene References")
@export var block_scene: PackedScene
@export var coin_scene: PackedScene
@export var hazard_scene: PackedScene
@export var player_scene: PackedScene

@export_category("Node References")
@export var player: Player

@export_category("Object Behavior")
@export var default_hazard_behavior: HazardBehavior
var hazard_behavior: HazardBehavior

@export_category("Limits and Sizes")
@export var grid_size: Vector2 = Vector2(0, 0)
@export var vertical_block_limit: float = 3
var current_max_height: float = 0
@export var horizontal_block_limit: float = 3
@export var block_size: float = 32

@export_category("Algorithm Tuning")
@export var thinning_strength: int = 3
@export var hazard_threshold: int = 5
var current_hazard_threshold: int = 0

@export_category("Juice Numbers")
@export var stun_duration: float = 0.8


#endregion

var live_blocks: Array[StaticBody2D]
var grid_spaces: Array[Vector2]
var occupied_grid_spaces: Array[Vector2]
var skip_stun: bool = false

func _ready() -> void:
	initialize_arena()
	initialize_grid()
	check_max_height()
	
	for i in get_tree().get_nodes_in_group("blocks"):
		live_blocks.append(i)
	
	SignalBus.game_start.connect(reset_arena)
	SignalBus.coin_collected.connect(coin_collected)
	SignalBus.round_ended.connect(skip_next_stun)
	SignalBus.info_request.connect(info_request)
	
	hazard_behavior.initialize_behavior()
	
	create_player()

func info_request(request_name: StringName, info: Dictionary) -> void:
	match request_name:
		"current_behavior":
			info["current_behavior"] = hazard_behavior

func assign_random_grid_space(body: Node2D, solid: bool = false, thin_pool: bool = false) -> Vector2:
	var space: Vector2 = grid_spaces.pick_random()
	
	grid_spaces.erase(space)
	
	if body is Player or solid == false:
		pass
	else:
		occupied_grid_spaces.append(space)
	
	if thin_pool == true:
		for i in range(thinning_strength):
			grid_spaces.erase(grid_spaces.pick_random())
	
	return space

func coin_collected() -> void:
	current_hazard_threshold += 1
	
	create_block()
	create_coin()
	if current_hazard_threshold == hazard_threshold:
		create_hazard()

func create_block(qty: int = 1) -> void:
	for i in qty:
		var new_block: Node2D = spawn_object(block_scene)
		var random_grid_space: Vector2 = assign_random_grid_space(new_block, true, true)
	
		live_blocks.append(new_block)
		
		new_block.global_position = random_grid_space
		add_vertical_layer(random_grid_space)

func create_coin(_qty: int = 1) -> void:
	var new_coin: Coin = spawn_object(coin_scene)
	var random_grid_space: Vector2 = assign_random_grid_space(new_coin, true)
	
	new_coin.global_position = random_grid_space

func create_hazard(_qty: int = 1) -> void:
	var new_hazard: Hazard = spawn_object(hazard_scene)
	var random_grid_space: Vector2 = assign_random_grid_space(new_hazard, true)
	
	new_hazard.global_position = random_grid_space
	new_hazard.behavior = hazard_behavior
	
	current_hazard_threshold = 0

func create_player() -> void:
	
	if player == null:
		var new_player: Player = spawn_object(player_scene)
		
		new_player.initialize_player(assign_random_grid_space(new_player))
		
		player = new_player

func spawn_object(scene: PackedScene) -> Node2D:
	var new_object: Node2D = scene.instantiate()
	
	call_deferred("add_child", new_object)
	
	return new_object

func add_vertical_layer(horiz_basis: Vector2 = Vector2.ZERO) -> void:
	for x in range(max(horiz_basis.x - block_size * horizontal_block_limit, block_size / 2), min(grid_size.x, horiz_basis.x + block_size * horizontal_block_limit), block_size):
		for y in range(horiz_basis.y - block_size * vertical_block_limit, horiz_basis.y - block_size, block_size):
			if grid_spaces.has(Vector2(x, y)) or y <= 0 or occupied_grid_spaces.has(Vector2(x, y)):
				pass
			else:
				grid_spaces.append(Vector2(x, y))
	check_max_height()

func check_max_height() -> void:
	if live_blocks.is_empty():
		return
		
	for block in live_blocks:
		if block.global_position.y < current_max_height:
			current_max_height -= block_size

func reset_arena() -> void: ## Relies on Player node existing and being ready
	clear_arena(true)
	
	initialize_arena()
	initialize_grid()
	
	create_coin()
	await get_tree().process_frame
	create_player()

func clear_arena(clear_player: bool = false) -> void:
	if clear_player == true and player != null:
		player.queue_free()
		
	for i in get_tree().get_nodes_in_group("game objects"):
		i.queue_free()

func initialize_arena() -> void:
	current_hazard_threshold = 0
	grid_spaces.clear()
	occupied_grid_spaces.clear()
	live_blocks.clear()
	hazard_behavior = default_hazard_behavior
	hazard_behavior.set_stats_to_default()

func initialize_grid() -> void:
	current_max_height = grid_size.y - block_size
	for x in range(block_size, grid_size.x - block_size, block_size):
		for y in range(current_max_height, current_max_height - vertical_block_limit * block_size, -block_size):
			grid_spaces.append(Vector2(x - block_size / 2, y - block_size / 2))

func new_hazard_behavior(new_behavior: HazardBehavior) -> void:
	hazard_behavior.set_stats_to_default()
	hazard_behavior = new_behavior

func update_hazard_behavior(new_behavior: HazardBehavior) -> void:
	for i in get_tree().get_nodes_in_group("game objects"):
		if i is Hazard:
			i.behavior = new_behavior

func stun_juice() -> void:
	SignalBus.player_stun.emit(stun_duration)

func skip_next_stun() -> void:
	skip_stun = true
