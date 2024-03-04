extends CharacterBody2D

const JUMP_VELOCITY = -900.0
var maxRunSpeed = 600
var speedIncrease = 200

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

var uncrouch = false

var inWater = false

var inputs = false
var firstDrop = true

var rollCD = 0.0

func _ready():
	$Sprite.play("idle")

func _physics_process(delta):
	inputs = %Game.gameActive

	var gravMult: float = 4.5

	if Input.is_action_pressed("Crouch") && inputs:
		crouching = true
		maxRunSpeed = 100
	else:
		crouching = false
		maxRunSpeed = 400
		uncrouch = false

	if jumping:
		if !Input.is_action_pressed("Jump") || is_on_floor() || velocity.y > 0:
			jumping = false
			crouchJump = false
			slideJump = false
			uncrouch = true
		else:
			if crouchJump:
				gravMult = 1.4
			else:
				gravMult = 2.0

	if !is_on_floor():
		velocity.y += gravity * delta * gravMult
		sliding = false
	elif is_on_floor() && wasInAir:
		AudioPlayer.instance.PlaySound(1, AudioPlayer.SoundType.SFX)
		if firstDrop:
			firstDrop = false
			%Game.gameActive = true
		if crouching && !uncrouch:
			sliding = true

	coyoteTime -= delta
	preJump -= delta
	rollCD -= delta

	if wasOnFloor && !is_on_floor() && velocity.y >= 0:
		coyoteTime = 0.1

	if Input.is_action_just_pressed("Jump") && !is_on_floor() && inputs:
		preJump = 0.1

	if ((Input.is_action_just_pressed("Jump") && ((is_on_floor() || coyoteTime > 0))) || (preJump > 0 && is_on_floor())) && (!rolling || coyoteTime > 0) && inputs:
		AudioPlayer.instance.PlaySound(0, AudioPlayer.SoundType.SFX)
		velocity.y = JUMP_VELOCITY
		jumping = true
		if crouching:
			if sliding:
				slideJump = true
				velocity.x *= 1.5
			else:
				crouchJump = true

	if Input.is_action_just_pressed("Roll") && !rolling && rollCD <= 0 && inputs:
		AudioPlayer.instance.PlaySound(2, AudioPlayer.SoundType.SFX)
		rolling = true
		if is_on_floor():
			coyoteTime = 0.1
		rollTimer = rollTime
		var tween: Tween = create_tween()
		tween.tween_property($Sprite, "rotation", deg_to_rad(360 * lastDirection), rollTime)

	if !rolling:
		var preserve = false
		var direction = Input.get_axis("Left", "Right")
		if !inputs:
			direction = 0
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
			rollCD = 0.5
			$RollBar.visible = true
			var tween = create_tween()
			$RollBar.value = 0
			tween.tween_property($RollBar, "value", 1, 0.5)
			tween.finished.connect(Callable(HideBar))
			currentRollSpeed = rollSpeed

	if abs(velocity.x) < 5:
		velocity.x = 0

	wasOnFloor = is_on_floor()
	wasInAir = !is_on_floor()

	move_and_slide()

	# for i in get_slide_collision_count():
	# 	var col = get_slide_collision(i)
	# 	if col.get_collider() is RigidBody2D:
	# 		col.get_collider().apply_central_impulse(-col.get_normal() * 50)

func HideBar():
	$RollBar.visible = false

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
				if sliding:
					$Sprite.play("sliding")
				else:
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

	if crouching && is_on_floor() && !rolling && !sliding:
		$Sprite.scale = Vector2(3, 1.5)
		$Sprite.offset = Vector2(0, 16)
		if sliding:
			pass
		else:
			pass
	else:
		$Sprite.scale = Vector2(3, 3)
		$Sprite.offset = Vector2(0, 0)

func EnterWater():
	inWater = true
	AudioPlayer.instance.PlaySound(4, AudioPlayer.SoundType.SFX)

func ExitWater():
	inWater = false
