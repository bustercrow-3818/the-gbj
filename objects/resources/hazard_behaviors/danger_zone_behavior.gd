## Basic circular red hazard. Deals small damage when entered.
extends HazardBehavior
class_name DangerZoneBehavior

@export var base_damage: int = 1
@export var stun_duration: float = 0.05

var damage: int

func set_stats_to_default() -> void:
	damage = base_damage

func collision_effect(_body: Node2D) -> void:
	if _body is Player:
		_body.plot_armor.adjust_plot_armor(-damage)
		SignalBus.player_stun.emit(stun_duration)
		SFXBus.play_sound("player_hurt", _body)
