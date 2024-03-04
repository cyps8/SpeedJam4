extends CanvasLayer

func MainMenuPressed():
	SceneManager.instance.ChangeScene(SceneManager.Scene.MAINMENU)

func TryAgainPressed():
	SceneManager.instance.ChangeScene(SceneManager.Scene.GAME)