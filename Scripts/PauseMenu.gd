extends CanvasLayer

class_name PauseMenu

func ResumeButton():
	GameManager.instance.TogglePause()

func OptionsButton():
	SceneManager.instance.OpenOptionsMenu()

func MainMenuButton():
	SceneManager.instance.ChangeScene(SceneManager.Scene.MAINMENU)
	get_tree().paused = false