extends Node

onready var Music = $Music
onready var MusicChanger = $ChangeMusic

var OverWorld = load("res://Assets/Music/Overworld.ogg")
var MainMenu = load("res://Assets/Music/MainMenuTheme.ogg")
var BossTheme = load("res://Assets/Music/04 Boss.ogg")
var EndTheme = load("res://Assets/Music/Outro Cutscene.wav")


func Play_Music():
	Music.play()

func StopMusic():
	MusicChanger.play("FadeOut")
	yield(MusicChanger, "animation_finished")
	Music.stop()

func ChangeMusic(MusicToPlay):
	MusicChanger.play("FadeOut")
	yield(MusicChanger, "animation_finished")
	Music.stream = MusicToPlay
	MusicChanger.play_backwards("FadeOut")
	Play_Music()

