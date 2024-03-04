extends Node

class_name GameManager
static var instance: GameManager

var pauseRef: PauseMenu
var paused: bool = false

func _ready():
	pauseRef = $PauseMenu
	remove_child(pauseRef)

	instance = self

func TogglePause():
	if !%Game.gameActive:
		return
		
	paused = !paused
	if paused:
		get_tree().paused = true
		add_child(pauseRef)
	else:
		get_tree().paused = false
		remove_child(pauseRef)
		AudioPlayer.instance.PlaySound(8, AudioPlayer.SoundType.SFX)


func _process(_delta):
	if Input.is_action_just_pressed("Pause") && !SceneManager.instance.optionsOpen:
		TogglePause()
	elif Input.is_action_just_pressed("ui_cancel") && !SceneManager.instance.optionsOpen && paused:
		TogglePause()
