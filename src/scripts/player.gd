extends CharacterBody2D

signal player_jumped

@onready var screenSize = get_viewport_rect().size
@onready var jumpSound = $JumpSound
@onready var landSound = $LandSound
@onready var anim = $AnimatedSprite2D

var was_on_floor = false
var jumps_left = 1

func _physics_process(delta: float) -> void:
	# Horizontal input with minimal acceleration (tighter feel)
	var direction = Input.get_axis("walk_left", "walk_right")
	var target_speed = direction * settings.SPEED
	velocity.x = move_toward(velocity.x, target_speed, settings.ACCELERATION * delta)

	# Gravity
	velocity.y += settings.GRAVITY * delta

	# Jumping (with double jump)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = settings.JUMP_VELOCITY
			jumps_left = 1
			jumpSound.play()
			anim.play("jump")
			player_jumped.emit()
		elif jumps_left > 0:
			velocity.y = settings.JUMP_VELOCITY * 0.9
			jumps_left -= 1
			jumpSound.play()
			anim.play("jump")
			player_jumped.emit()

	# Variable jump height
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= settings.JUMP_RELEASE_MULTIPLIER

	# Landing logic
	if is_on_floor():
		if not was_on_floor:
			landSound.play()
		jumps_left = 1

	# Animation logic
	if is_on_floor():
		if direction != 0:
			anim.play("walk")
		else:
			anim.play("idle")
	else:
		anim.play("jump")
	
	# Movement and slide
	move_and_slide()
	
	# Update floor tracking
	was_on_floor = is_on_floor()

	# Keep player within horizontal bounds
	position.x = clamp(position.x, -screenSize.x/2, screenSize.x/2)
	
