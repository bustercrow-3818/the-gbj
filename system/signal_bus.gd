extends Node

@warning_ignore_start("unused_signal")
signal player_damaged(amount: int)
signal player_dead
signal player_stun(duration: float)
signal player_ready

signal max_plot_armor_changed(new_max: int, current_value)
signal plot_armor_changed(new_amount: int)
signal plot_points_changed(new_amount: int)

signal adjust_movement_stats(stat: StringName, adjustment: float)

signal chapter_ended(new_chapter: int)

signal good_news_chosen
signal bad_news_chosen

signal coin_collected

signal game_start
signal game_pause
signal game_resume
signal round_ended
signal return_to_main_menu

signal time_out

signal news_stats_adjusted(stat: StringName, _data: Dictionary)
signal hazard_behavior_changed(new_behavior: HazardBehavior)

signal info_request(request_name: StringName, info: Dictionary)

@warning_ignore_restore("unused_signal")
