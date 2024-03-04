extends Floatable

func _ready():
    $Sprite.play("open")

func PlayerEated(_body):

    _body.Eaten()

    $Sprite.play("bite")
    var tween = create_tween()
    tween.tween_interval(1)
    tween.finished.connect(Callable(ResetJaw))

func ResetJaw():
    $Sprite.play("open")

func GatorNoise(_body):
    AudioPlayer.instance.PlaySound(9, AudioPlayer.SoundType.SFX)