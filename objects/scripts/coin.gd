extends Node2D
class_name Coin

func _ready() -> void:
	%Area2D.body_entered.connect(collect)

func collect(body: Node2D) -> void:
	if body is Player:
		SignalBus.coin_collected.emit()
		SFXBus.play_sound("coin_grab", body)
		queue_free()
