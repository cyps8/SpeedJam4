extends Area2D

var playerInRange = false

signal interacted

var activated: bool = false

func _ready():
	connect("interacted", Callable(%Game, "ResetFlow"))
	connect("interacted", Callable(%Game, "TriggerCheckpoint"))

func _process(_delta):
	if playerInRange && Input.is_action_just_pressed("Interact") && !activated && !%Player.rolling && %Game.gameActive:
		emit_signal("interacted")
		activated = true
		AudioPlayer.instance.PlaySound(3, AudioPlayer.SoundType.SFX)
		%Player.ValveInteract(position)
		var tween = create_tween()
		tween.tween_property($Sprite, "rotation", deg_to_rad(-360), 2)
		$SpriteInt.visible = false
		$TextInt.visible = false

func playerEntered(_body):
	playerInRange = true
	if !activated:
		$SpriteInt.visible = true
		$TextInt.visible = true

func playerExited(_body):
	playerInRange = false
	$SpriteInt.visible = false
	$TextInt.visible = false