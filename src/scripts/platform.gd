extends Node2D

var timer: float = 0.0

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

# Preload platform textures
var platform_textures = [
	preload("res://assets/sprites/platforms/1.png"),
	preload("res://assets/sprites/platforms/2.png"),
	preload("res://assets/sprites/platforms/3.png"),
	preload("res://assets/sprites/platforms/4.png"),
	preload("res://assets/sprites/platforms/5.png"),
	preload("res://assets/sprites/platforms/6.png"),
]

func _ready():
	randomize_texture()
	randomize_width()
	
func randomize_texture():
	sprite.texture = platform_textures.pick_random()

func randomize_width():
	var new_width = settings.possible_widths.pick_random()

	# Adjust sprite size (assuming default sprite is 100px wide)
	var sprite_texture_size = sprite.texture.get_size()
	sprite.scale.x = new_width / sprite_texture_size.x
	sprite.scale.y = sprite.scale.x
	# Adjust collision shape width
	var shape = collision_shape.shape.duplicate()
	collision_shape.shape = shape
	shape.size.x = new_width * 0.9
	
func _process(delta: float) -> void:
	var player_y = get_parent().get_parent().get_node("Player").position.y
	if  player_y - position.y > settings.distance_allowed * 4:
		settings.platform_spawn_y = position.y + settings.distance_allowed
		queue_free()
	else:
		# advance our internal clock
		timer += delta
		# phase from 0→1→0 over fade_duration
		var phase = (sin(2.0 * PI * timer / settings.fade_duration) + 1.0) * 0.5
		# blend between min_opacity and fully opaque
		var alpha = lerp(settings.min_opacity, 1.0, phase)
		
		# apply to sprite
		$Sprite2D.modulate.a = alpha
		# enable collision only if sufficiently opaque
		$CollisionShape2D.disabled = alpha < settings.collision_threshold
	
