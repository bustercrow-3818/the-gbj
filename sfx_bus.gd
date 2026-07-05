extends Node

const SOUNDS: Dictionary[StringName, AudioStream] = {
	"coin_grab" : preload("res://assets/sfx/coin_sound.wav"),
	"jump" : preload("res://assets/sfx/hup.mp3"),
	"land" : preload("res://assets/sfx/138476__justinvoke__steptap.wav"),
	"player_hurt" : preload("res://assets/sfx/hurt.wav")
}

const pitch_var_min: float = 0.9
const pitch_var_max: float = 1.1

func _ready() -> void:
	
	pass

func play_sound(sound: StringName, parent: Node) -> void:
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	
	parent.add_child(audio)
	
	audio.stream = SOUNDS[sound]
	audio.pitch_scale = randf_range(pitch_var_min, pitch_var_max)
	audio.play()
	await audio.finished
	audio.queue_free()
	pass
