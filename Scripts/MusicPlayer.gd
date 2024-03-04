extends AudioStreamPlayer

class_name MusicPlayer

static var instance: MusicPlayer

enum Song { MENU = 0, GAME = 1, WIN = 2, LOSE = 3}

@export var songs: Array[AudioStream]

func _ready():
	instance = self

	for song in songs:
		load(song.get_path())

func PlaySong(song: Song = Song.MENU) -> void:
	stream = songs[song]
	play()

func StopSong() -> void:
	stop()