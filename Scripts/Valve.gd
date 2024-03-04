extends Area2D

var playerInRange = false

signal interacted

var activated: bool = false

func _process(_delta):
	if playerInRange && Input.is_action_just_pressed("Interact") && !activated:
		emit_signal("interacted")
		activated = true
		AudioPlayer.instance.PlaySound(3, AudioPlayer.SoundType.SFX)

func playerEntered(_body):
	playerInRange = true

func playerExited(_body):
	playerInRange = false