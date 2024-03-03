extends CharacterBody2D

const JUMP_VELOCITY = -800.0
var maxRunSpeed = 400
var speedIncrease = 100

var rollSpeed = 800
var currentRollSpeed = 800

var wasOnFloor = false
var coyoteTime = 0
var preJump = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var rolling = false
var lastDirection = 1
var rollTimer = 0.0
var rollTime = 0.2

var jumping = false
var wasInAir = false
var crouching = false
var sliding = false

var crouchJump = false
var slideJump = false

func _ready():
	$Sprite.play("idle")

func _physics_process(delta):
	
	var gravMult: float = 3.5

	if Input.is_action_pressed("Crouch"):
		crouching = true
		maxRunSpeed = 100
	else:
		crouching = false
		maxRunSpeed = 400

	if jumping:
		if !Input.is_action_pressed("Jump") || is_on_floor() || velocity.y > 0:
			jumping = false
			crouchJump = false
			slideJump = false
		else:
			if crouchJump:
				gravMult = 1.5
			else:
				gravMult = 2.0

	if !is_on_floor():
		velocity.y += gravity * delta * gravMult
		sliding = false
	elif is_on_floor() && wasInAir && crouching:
		sliding = true

	coyoteTime -= delta
	preJump -= delta

	if wasOnFloor && !is_on_floor() && velocity.y >= 0:
		coyoteTime = 0.1

	if Input.is_action_just_pressed("Jump") && !is_on_floor():
		preJump = 0.1

	if ((Input.is_action_just_pressed("Jump") && ((is_on_floor() || coyoteTime > 0))) || (preJump > 0 && is_on_floor())) && (!rolling || coyoteTime > 0):
		velocity.y = JUMP_VELOCITY
		jumping = true
		if crouching:
			if sliding:
				slideJump = true
				velocity.x *= 1.5
			else:
				crouchJump = true

	if Input.is_action_just_pressed("Roll") && !rolling:
		rolling = true
		if is_on_floor():
			coyoteTime = 0.1
		rollTimer = rollTime
		var tween: Tween = create_tween()
		tween.tween_property($Sprite, "rotation", deg_to_rad(360 * lastDirection), rollTime)

	if !rolling:
		var preserve = false
		var direction = Input.get_axis("Left", "Right")
		if direction:
			if sliding:
				if !(velocity.x > 0 && direction > 0 || velocity.x < 0 && direction < 0) || !crouching:
					sliding = false
			elif !((velocity.x >= maxRunSpeed && direction > 0) || (velocity.x <= -maxRunSpeed && direction < 0)):
				velocity.x += direction * speedIncrease
				lastDirection = direction
			else:
				preserve = true
		else:
			sliding = false
		if is_on_floor():
			if sliding:
				velocity.x = move_toward(velocity.x, 0, abs(velocity.x) * 0.02)
			else:
				velocity.x = move_toward(velocity.x, 0, abs(velocity.x) * 0.25)
		elif preserve == false:
			velocity.x = move_toward(velocity.x, 0, abs(velocity.x) * 0.1)
		else:
			velocity.x = move_toward(velocity.x, 0, abs(velocity.x) * 0.01)
	else:
		if (velocity.x > rollSpeed && lastDirection > 0) || (velocity.x < -rollSpeed && lastDirection < 0):
			currentRollSpeed = abs(velocity.x)
		velocity.x = lastDirection * currentRollSpeed
		rollTimer -= delta
		if rollTimer <= 0:
			rolling = false
			currentRollSpeed = rollSpeed

	if abs(velocity.x) < 5:
		velocity.x = 0

	wasOnFloor = is_on_floor()
	wasInAir = !is_on_floor()

	move_and_slide()

func _process(_delta):
	if lastDirection > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

	if rolling:
		$Sprite.play("rolling")
	else:
		if is_on_floor():
			if velocity.x != 0:
				$Sprite.play("walking")
				$Sprite.speed_scale = abs(velocity.x) / maxRunSpeed * 2.5
			else:
				$Sprite.play("idle")
				$Sprite.speed_scale = 1
		else:
			if velocity.y < 0:
				$Sprite.play("jumping")
			else:
				$Sprite.play("falling")
	

	if !rolling:
		$Sprite.rotation = 0

	if crouching && is_on_floor() && !rolling:
		$Sprite.scale = Vector2(3, 1.5)
		$Sprite.offset = Vector2(0, 16)
		if sliding:
			pass
		else:
			pass
	else:
		$Sprite.scale = Vector2(3, 3)
		$Sprite.offset = Vector2(0, 0)
