extends CharacterBody2D

const JUMP_VELOCITY = -800.0
var maxRunSpeed = 400
var speedIncrease = 100

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

func _ready():
	$Sprite.play("idle")

func _physics_process(delta):
	
	var gravMult: float = 3.0

	if jumping:
		if !Input.is_action_pressed("Jump") || is_on_floor() || velocity.y > 0:
			jumping = false
		else:
			gravMult = 2.0

	if not is_on_floor():
		velocity.y += gravity * delta * gravMult

	coyoteTime -= delta
	preJump -= delta

	if wasOnFloor && !is_on_floor() && velocity.y >= 0:
		coyoteTime = 0.1

	if Input.is_action_just_pressed("Jump") && !is_on_floor():
		preJump = 0.1

	if ((Input.is_action_just_pressed("Jump") && (is_on_floor()  || coyoteTime > 0)) || (preJump > 0 && is_on_floor())) && !rolling:
		velocity.y = JUMP_VELOCITY
		jumping = true

	if Input.is_action_just_pressed("Roll") && !rolling:
		rolling = true
		rollTimer = rollTime
		var tween: Tween = create_tween()
		tween.tween_property($Sprite, "rotation", deg_to_rad(360 * lastDirection), rollTime)

	if !rolling:
		var preserve = false
		var direction = Input.get_axis("Left", "Right")
		if direction:
			if !((velocity.x >= maxRunSpeed && direction > 0) || (velocity.x <= -maxRunSpeed && direction < 0)):
				velocity.x += direction * speedIncrease
				lastDirection = direction
			else:
				preserve = true
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, abs(velocity.x) * 0.25)
		elif preserve == false:
			velocity.x = move_toward(velocity.x, 0, abs(velocity.x) * 0.1)
		else:
			velocity.x = move_toward(velocity.x, 0, abs(velocity.x) * 0.01)
	else:
		velocity.x = lastDirection * 800
		rollTimer -= delta
		if rollTimer <= 0:
			rolling = false

	wasOnFloor = is_on_floor()

	move_and_slide()

func _process(_delta):
	if lastDirection > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

	if !rolling:
		$Sprite.rotation = 0
