extends CanvasLayer

var creditsCanvas: CanvasLayer

func _ready():
	creditsCanvas = $Credits
	remove_child(creditsCanvas)

func StartButton():
	SceneManager.instance.ChangeScene(SceneManager.Scene.GAME)

func OptionsButton():
	SceneManager.instance.OpenOptionsMenu()

func QuitButton():
	get_tree().quit()

func CreditsButton():
	add_child(creditsCanvas)

func CreditsBackButton():
	remove_child(creditsCanvas)
