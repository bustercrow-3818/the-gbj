extends Node2D
class_name MainRoom

@export_category("Other Stats")
@export var music_fade_time: float = 2.0

@export_category("Node References")
@export var player: Player
@export var object_manager: ObjectManager
@export var ui_manager: UIManager
@export var bgm_music: AudioStreamPlayer

func _ready() -> void:
	SignalBus.game_start.connect(start_game)
	SignalBus.return_to_main_menu.connect(hide)
	SignalBus.player_dead.connect(taper_music)

func start_game() -> void:
	show()
	bgm_music.play()

func quit_to_menu() -> void:
	bgm_music.stop()
	hide()
	

func taper_music() -> void:
	var music_tween: Tween = create_tween()
	
	music_tween.tween_property(bgm_music, "volume_db", -80.0, music_fade_time)
