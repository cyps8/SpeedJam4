extends Area2D

func _ready():
	for waterfall in get_tree().get_nodes_in_group("Waterfall"):
		waterfall.visible = false

func Flood():
	var tween = create_tween()
	tween.tween_property(self, "position:y", 180, 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	for waterfall in get_tree().get_nodes_in_group("Waterfall"):
		waterfall.visible = true

func RaiseWater():
	var tween = create_tween()
	tween.tween_property(self, "position:y", 615, 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	print("water rising!")
	%BackLabel.visible = true
	for waterfall in get_tree().get_nodes_in_group("Waterfall"):
		waterfall.visible = true

	for valve in get_tree().get_nodes_in_group("ValveReset"):
		if !valve.is_in_group("End"):
			valve.activated = false

func _process(_delta):
	%WaterSprite.position.y = position.y - 506

	for waterfall in get_tree().get_nodes_in_group("Waterfall"):
		waterfall.position.y = position.y - 506

func OnEntered(_body):
	if _body == %Player || _body.is_in_group("Floatable"):
		_body.EnterWater()

func OnExited(_body):
	if _body == %Player || _body.is_in_group("Floatable"):
		_body.ExitWater()