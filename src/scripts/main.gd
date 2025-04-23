extends Node2D

@export var platform_scene: PackedScene
@onready var screen_size = get_viewport_rect().size


func _ready():
	settings.setup()
	settings.platform_spawn_y = $Player.position.y - settings.min_gap_y

	
func spawn_platform(pos: Vector2):
	var platform = platform_scene.instantiate()
	platform.position = pos
	$Platforms.add_child(platform)

func _process(delta):
	var player_y = $Player.position.y
	var player_x = $Player.position.x
	
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
