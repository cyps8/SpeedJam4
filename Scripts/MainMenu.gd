extends CanvasLayer

func StartButton():
	SceneManager.instance.ChangeScene(SceneManager.Scene.GAME)

func OptionsButton():
	SceneManager.instance.OpenOptionsMenu()

func QuitButton():
	get_tree().quit()