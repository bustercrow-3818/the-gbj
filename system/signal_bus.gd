extends Node

@warning_ignore_start("unused_signal")
signal player_damaged(amount: int)
signal player_dead
signal player_stun(duration: float)

signal coin_collected

signal game_start
signal game_pause
signal game_resume
signal round_ended

signal time_out

signal news_stats_adjusted(_data: Dictionary)
signal hazard_behavior_changed(new_behavior: HazardBehavior)

signal info_request(request_name: StringName, info: Dictionary)

@warning_ignore_restore("unused_signal")
