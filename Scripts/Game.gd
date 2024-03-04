extends Node2D

var timer: float = 0.0

var gameActive = false

func _ready():
	pass # Replace with function body.

func _process(_delta):
	if !gameActive:
		return

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

func Win():
	if timer < SceneManager.instance.bestTime:
		SceneManager.instance.bestTime = timer

	MusicPlayer.instance.PlaySong(MusicPlayer.Song.WIN)
	gameActive = false
	%WinScreen.visible = true
	
	SetText(%WinTime, timer, "TIME")
	SetText(%BestTime, SceneManager.instance.bestTime, "BEST")

func SetText(label: Label, time: float, prefix: String = ""):
	var seconds = time
	var minutes: int = 0
	var hours: int = 0
	while seconds >= 60:
		seconds -= 60
		minutes += 1
	while minutes >= 60:
		minutes -= 60
		hours += 1
	if hours == 0:
		label.text = prefix + ": " + "%02d" % minutes + ":" + "%05.2f" % seconds
	else:
		label.text = prefix + ": " + "%02d" % hours + ":" + "%02d" % minutes + ":" + "%05.2f" % seconds