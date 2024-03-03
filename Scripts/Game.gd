extends Node2D

var timer: float = 0.0

func _ready():
	pass # Replace with function body.

func _process(_delta):
	timer += _delta
	var seconds = timer
	var minutes: int = 0
	var hours: int = 0
	while seconds >= 60:
		seconds -= 60
		minutes += 1
	while minutes >= 60:
		minutes -= 60
		hours += 1
	if hours == 0:
		%Timer.text = "TIME: " + "%02d" % minutes + ":" + "%05.2f" % seconds
	else:
		%Timer.text = "TIME: " + "%02d" % hours + ":" + "%02d" % minutes + ":" + "%05.2f" % seconds
