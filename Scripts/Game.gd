extends Node2D

var timer: float = 0.0

var gameActive = false

var overFlowTime = 0.0

var overFlowLimit = 50.0

var drops: Array[TextureProgressBar] = []
var hearts: Array[TextureRect] = []

var respawnPos = Vector2(-485, -51)

var currentHearts = 5

signal overflow

func _ready():
	for i in %Drops.get_children():
		drops.append(i)

	for i in %Hearts.get_children():
		hearts.append(i)

func LoseHeart() -> bool:
	currentHearts -= 1
	hearts[currentHearts].visible = false
	if currentHearts == 0:
		LostAllHearts()
		return true
	return false

func LostAllHearts():
	gameActive = false
	MusicPlayer.instance.PlaySong(MusicPlayer.Song.LOSE)
	var tween = create_tween()
	tween.tween_interval(2)
	tween.tween_callback(Lose)
	%YouLost.text = "YOU LOST ALL\n OF YOUR HEARTS\n AND YOU LOST :("

func _process(_delta):
	if !gameActive:
		return

	overFlowTime += _delta
	UpdateDrops()
	$WaterSounds.volume_db = linear_to_db(overFlowTime / overFlowLimit)
	if overFlowTime > overFlowLimit:
		OverFlow()

	timer += _delta
	SetText(%Timer, timer, "TIME")

func Win():
	if timer < SceneManager.instance.bestTime:
		SceneManager.instance.bestTime = timer

	MusicPlayer.instance.PlaySong(MusicPlayer.Song.WIN)
	gameActive = false
	%WinScreen.visible = true
	
	SetText(%WinTime, timer, "TIME")
	SetText(%BestTime, SceneManager.instance.bestTime, "BEST")

func OverFlow():
	emit_signal("overflow")
	gameActive = false
	MusicPlayer.instance.PlaySong(MusicPlayer.Song.LOSE)
	var tween = create_tween()
	tween.tween_interval(2)
	tween.tween_callback(Lose)

func Lose():
	%LoseScreen.visible = true

func TriggerCheckpoint():
	var tween = create_tween()
	tween.tween_interval(2)
	tween.tween_callback(SetCheckpoint)
	print("checkpoint triggered!")

func SetCheckpoint():
	respawnPos = %Player.position
	%Player.CheckpointActivated()
	AudioPlayer.instance.PlaySound(5, AudioPlayer.SoundType.SFX)

func UpdateDrops():
	var overflowSection = overFlowLimit / 5
	var currentFlow = overFlowTime
	for d in drops:
		if currentFlow > overflowSection:
			currentFlow -= overflowSection
			d.value = 1
		elif currentFlow > 0:
			d.value = (currentFlow / overflowSection)
			currentFlow = 0
		else:
			d.value = 0

func ResetFlow():
	overFlowTime = 0

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