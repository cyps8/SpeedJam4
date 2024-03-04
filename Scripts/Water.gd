extends Area2D

func Flood():
	var tween = create_tween()
	tween.tween_property(self, "position:y", 180, 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func RaiseWater():
	var tween = create_tween()
	tween.tween_property(self, "position:y", 615, 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	print("water rising!")
	%BackLabel.visible = true

func _process(_delta):
	%WaterSprite.position.y = position.y - 506

func OnEntered(_body):
	if _body == %Player || _body.is_in_group("Floatable"):
		_body.EnterWater()

func OnExited(_body):
	if _body == %Player || _body.is_in_group("Floatable"):
		_body.ExitWater()