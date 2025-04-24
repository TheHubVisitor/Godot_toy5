extends CanvasLayer

# Stats references
@onready var elevation_label = $ColorRect/StatsPanel/Elevation/Label
@onready var time_label = $ColorRect/StatsPanel/Time/Label
@onready var highest_label = $ColorRect/StatsPanel/Highest/Label
@onready var streak_label = $ColorRect/StatsPanel/Streak/Label
@onready var steps_label = $ColorRect/StatsPanel/Steps/Label
@onready var calories_label = $ColorRect/StatsPanel/Calories/Label

var play_time: float = 0.0
var elevation: float = 0.0
var highest_elevation: float = 0.0
var streak: int = 0
var steps: int = 0
var calories: float = 0.0

func _process(delta: float) -> void:
	play_time += delta
	update_time(play_time)

func update_elevation(player_y: float):
	# Assuming higher negative values mean higher elevation
	elevation = -player_y
	elevation_label.text = "%d m" % (elevation - 45)
	
	if elevation > highest_elevation:
		highest_elevation = elevation
		highest_label.text = "%d m" % (highest_elevation - 45)

func update_time(seconds: float):
	var minutes = int(seconds / 60)
	var secs = int(seconds) % 60
	time_label.text = "%02d:%02d" % [minutes, secs]

func update_streak(current_streak: int):
	streak = current_streak
	streak_label.text = "%d" % streak

func update_steps(total_steps: int):
	steps = total_steps
	steps_label.text = "%d" % steps

func update_calories(total_calories: float):
	calories = total_calories
	calories_label.text = "%.1f kJ" % calories
