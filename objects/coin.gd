extends Node2D
class_name Coin

func _ready() -> void:
	%Area2D.body_entered.connect(collect)

func collect(body: Node2D) -> void:
	if body is Player:
		body.collect_coin()
		queue_free()
