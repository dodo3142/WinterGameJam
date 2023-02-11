extends Node

onready var Music = $Music
onready var MusicChanger = $ChangeMusic

func Play_Music():
	Music.play()

func StopMusic():
	MusicChanger.play("FadeOut")
	yield(MusicChanger, "animation_finished")
	Music.stop()

func ChangeMusic(MusicToPlay):
	MusicChanger.play("FadeOut")
	yield(MusicChanger, "animation_finished")
	if File.new().file_exists(MusicToPlay):
		  var NewMusic = load(MusicToPlay) 
		  Music.stream = NewMusic
	MusicChanger.play_backwards("FadeOut")
	Play_Music()

