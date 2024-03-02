extends CanvasLayer

class_name OptionsMenu

func BackButton():
	SceneManager.instance.CloseOptionsMenu()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		BackButton()
