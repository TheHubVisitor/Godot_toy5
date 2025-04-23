extends Camera2D

var initial_camera_y: float
var follow_speed: float = 6.0

func _ready():
	initial_camera_y = global_position.y

func _process(delta):
	var player_y = get_parent().get_node("Player").global_position.y

	if player_y < initial_camera_y:
		global_position.y = lerp(global_position.y, player_y, follow_speed * delta)
	elif global_position.y != initial_camera_y:
		global_position.y = lerp(global_position.y, initial_camera_y, follow_speed * delta)
