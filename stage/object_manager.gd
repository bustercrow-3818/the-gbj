extends Node2D
class_name ObjectManager

@export_category("Node References")
@export var block_scene: PackedScene
@export var coin_scene: PackedScene
@export var killer_scene: PackedScene
@export var player: Player

@export_category("Limits and Sizes")
@export var grid_size: Vector2 = Vector2(0, 0)
@export var vertical_block_limit: float = 3
var current_max_height: float = 0
@export var horizontal_block_limit: float = 3
@export var block_size: float = 32

@export_category("Algorithm Tuning")
@export var thinning_strength: int = 3
@export var killer_threshold: int = 5
var current_killer_threshold: int = 0

@export_category("Juice Numbers")
@export var pause_duration: float = 0.8

var live_blocks: Array[StaticBody2D]
var grid_spaces: Array[Vector2]
var occupied_grid_spaces: Array[Vector2]

func _ready() -> void:
	initialize_grid()
	check_max_height()
	
	for i in get_tree().get_nodes_in_group("blocks"):
		live_blocks.append(i)
	
	SignalBus.game_start.connect(reset_arena)

func assign_random_grid_space(body: Node2D, thin_strength: int = 0) -> Vector2:
	var space: Vector2 = grid_spaces.pick_random()
	
	grid_spaces.erase(space)
	
	if body is Player:
		pass
	else:
		call_deferred("add_child", body)
		occupied_grid_spaces.append(space)
	
	for i in range(thin_strength):
		grid_spaces.erase(grid_spaces.pick_random())
	
	return space

func create_block(qty: int = 1, spawn_coin: bool = true, spawn_killer: bool = true) -> void:
	#var new_block: StaticBody2D = block_scene.instantiate()
	#var random_grid_space: Vector2 = assign_random_grid_space(new_block, thinning_strength)
	
	for i in qty:
		var new_block: StaticBody2D = block_scene.instantiate()
		var random_grid_space: Vector2 = assign_random_grid_space(new_block, thinning_strength)
	
		live_blocks.append(new_block)
		
		new_block.global_position = random_grid_space
		add_vertical_layer(random_grid_space)
	
	if spawn_coin == true:
		create_coin()
	
	if spawn_killer == true:
		current_killer_threshold += 1
		if current_killer_threshold == killer_threshold:
			create_killer()
	
	pause_juice()
	
func create_coin() -> void:
	var new_coin: Coin = coin_scene.instantiate()
	var random_grid_space: Vector2
	
	random_grid_space = grid_spaces.pick_random()
	
	call_deferred("add_child", new_coin)
	
	new_coin.global_position = random_grid_space
	set_grid_space_occupied(random_grid_space)

func create_killer() -> void:
	var new_killer: Killer = killer_scene.instantiate()
	var random_grid_space: Vector2
	
	random_grid_space = grid_spaces.pick_random()
	
	call_deferred("add_child", new_killer)
	
	new_killer.global_position = random_grid_space
	set_grid_space_occupied(random_grid_space)
	
	current_killer_threshold = 0

func set_grid_space_occupied(space: Vector2, thinning: bool = false) -> void:
	grid_spaces.erase(space)
	occupied_grid_spaces.append(space)
	
	if thinning == true:
		for i in range(thinning_strength):
			grid_spaces.erase(grid_spaces.pick_random())

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

func reset_arena() -> void:
	current_killer_threshold = 0
	grid_spaces.clear()
	occupied_grid_spaces.clear()
	live_blocks.clear()
	
	for i in get_tree().get_nodes_in_group("game objects"):
		i.queue_free()
		
	initialize_grid()
	
	create_coin()
	
	player.initialize_player(assign_random_grid_space(player))

func initialize_grid() -> void:
	current_max_height = grid_size.y - block_size
	for x in range(block_size, grid_size.x - block_size, block_size):
		for y in range(current_max_height, current_max_height - vertical_block_limit * block_size, -block_size):
			grid_spaces.append(Vector2(x - block_size / 2, y - block_size / 2))

func pause_juice() -> void:
	SignalBus.player_stun.emit(pause_duration)
