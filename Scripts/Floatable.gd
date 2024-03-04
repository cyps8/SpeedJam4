extends RigidBody2D

class_name Floatable

var inWater = false

func EnterWater():
	inWater = true
	gravity_scale = 0.5

func ExitWater():
	inWater = false

func _physics_process(_delta):
	if inWater && position.y > %WaterSprite.position.y:
		if position.y - %WaterSprite.position.y > 100:
			linear_velocity.y = -100
		else:
			linear_velocity.y = -(position.y - %WaterSprite.position.y)