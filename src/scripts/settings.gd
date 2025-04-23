extends Node
class_name settings

# player physics settings
static var SPEED = 350.0
static var ACCELERATION = 2000.0

static var JUMP_VELOCITY = -500.0
static var GRAVITY = 900.0
static var JUMP_RELEASE_MULTIPLIER = 0.5

static var max_jump_height: float
static var max_jump_width: float

# difficulty tuning
static var min_gap_y: float = 35
static var max_gap_y: float
static var max_delta_x: float

# platform settings
static var possible_widths: Array[float] = [50, 70, 80, 100, 120]
static var fade_duration: float = 10.0
static var min_opacity: float = 0.2
static var collision_threshold: float = 0.5
static var distance_allowed: float = 100

static var platform_spawn_y: float

static var current_mode = "easy"

static func set_mode(mode_name):
	current_mode = mode_name

static func setup():
	max_jump_height = (JUMP_VELOCITY * JUMP_VELOCITY) / (2 * GRAVITY)
	max_jump_width = SPEED * (2 * abs(JUMP_VELOCITY)) / GRAVITY
	
	match current_mode:
		"easy":
			max_gap_y = max_jump_height * 0.4
			max_delta_x = max_jump_width * 0.5
			fade_duration = 12.0
			min_opacity = 0.4
			collision_threshold = 0.3

		"hard":
			max_gap_y = max_jump_height * 0.55
			max_delta_x = max_jump_width * 0.6
			fade_duration = 9.0
			min_opacity = 0.3
			collision_threshold = 0.4

		"expert":
			min_gap_y = 30
			max_gap_y = max_jump_height * 0.75
			max_delta_x = max_jump_width * 0.75
			fade_duration = 7.0
			min_opacity = 0.2
			collision_threshold = 0.5

		"forget_it":
			min_gap_y = 20
			max_gap_y = max_jump_height * 0.95
			max_delta_x = max_jump_width * 0.9
			fade_duration = 7.0
			min_opacity = 0.2
			collision_threshold = 0.5
