extends Node

@warning_ignore_start("unused_signal")
signal player_dead
signal player_stun(duration: float)

signal game_start
signal game_pause
signal game_resume

signal time_out

signal news_stats_adjusted(_data: Dictionary)


@warning_ignore_restore("unused_signal")
