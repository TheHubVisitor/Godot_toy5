extends CharacterBody2D

@onready var screenSize = get_viewport_rect().size
@onready var jumpSound = $JumpSound
@onready var landSound = $LandSound
@onready var anim = $AnimatedSprite2D

var was_on_floor = false
var jumps_left = 1

func _physics_process(delta: float) -> void:
	# Horizontal input and smooth acceleration
	var direction = Input.get_axis("walk_left", "walk_right")
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * settings.MAX_SPEED, settings.ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, settings.FRICTION * delta)

	# Gravity (vertical movement)
	velocity.y += settings.GRAVITY * delta

	# Jumping logic (with double jump)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = settings.JUMP_VELOCITY
			jumps_left = 1  # Allow one additional jump in air
			jumpSound.play()
			anim.play("jump")
		elif jumps_left > 0:
			velocity.y = settings.JUMP_VELOCITY * 0.9  # slightly smaller double jump
			jumps_left -= 1
			jumpSound.play()
			anim.play("jump")

	# Variable jump height
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= settings.JUMP_RELEASE_MULTIPLIER

	# Landing sound and jump reset
	if is_on_floor():
		if not was_on_floor:
			landSound.play()
		jumps_left = 1

	# Animation logic
	if is_on_floor():
		anim.play("walk" if direction != 0 else "idle")
	else:
		anim.play("jump")

	# Movement and slide
	move_and_slide()

	# Update floor tracking
	was_on_floor = is_on_floor()

	# Keep player inside horizontal screen bounds
	position.x = clamp(position.x, -screenSize.x/2, screenSize.x/2)
