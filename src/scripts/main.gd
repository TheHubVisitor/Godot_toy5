extends Node2D

@export var platform_scene: PackedScene
@onready var screen_size = get_viewport_rect().size
@onready var player = $Player
@onready var hud = $HUD

var total_jumps = 0
var jump_streak = 0
var total_horizontal_movement = 0.0
var last_player_x = 0.0

# Track recent elevations clearly
var last_player_y = 0.0
var recent_peak_y = 0.0

func _ready():
	settings.setup()
	settings.platform_spawn_y = player.position.y - settings.min_gap_y
	last_player_x = player.position.x
	last_player_y = player.position.y
	recent_peak_y = player.position.y

	player.player_jumped.connect(_on_player_jumped)

	$UI/Popup.show_popup()
	$"01CinematicAmbient".play()

func spawn_platform(pos: Vector2):
	var platform = platform_scene.instantiate()
	platform.position = pos
	$Platforms.add_child(platform)

func _process(_delta):
	var player_y = player.position.y
	var player_x = player.position.x

	# Track horizontal distance moved each frame
	total_horizontal_movement += abs(player_x - last_player_x)
	last_player_x = player_x
	
	update_hud()
	
	if player_y < settings.platform_spawn_y:
		settings.platform_spawn_y = player_y - settings.distance_allowed
	
	# Spawn new platforms ahead as player climbs
	while settings.platform_spawn_y > player_y - settings.distance_allowed:
		settings.platform_spawn_y -= randf_range(settings.min_gap_y, settings.max_gap_y)
		spawn_platform(Vector2(
			clamp(
				randf_range(player_x - settings.max_delta_x, player_x + settings.max_delta_x), 
				-screen_size.x/2, 
				screen_size.x/2
			),
			settings.platform_spawn_y
		))
		
	last_player_y = player_y

func update_hud():
	var calories = calculate_fake_calories()
	hud.update_elevation(player.position.y)
	hud.update_steps(total_jumps)
	hud.update_streak(jump_streak)
	hud.update_calories(calories)

func calculate_fake_calories() -> float:
	var jump_calories = total_jumps * 0.3  # jumps are higher effort
	var move_calories = total_horizontal_movement * 0.01  # smaller increment per unit moved
	return jump_calories + move_calories
	
func _on_player_jumped():
	var player_y = player.position.y
	total_jumps += 1
	
	if player_y > recent_peak_y + settings.distance_allowed / 2:
		jump_streak = 1  # streak resets but counts current jump as new streak start
		recent_peak_y = player_y
	else:
		jump_streak += 1

	if player_y < recent_peak_y - settings.distance_allowed / 2:
		recent_peak_y = player_y

func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/start.tscn")
