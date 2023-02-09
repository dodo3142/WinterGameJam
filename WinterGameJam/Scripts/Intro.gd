extends Control



func _on_VideoPlayer_finished():
	MusicController.ChangeMusic("res://Assets/Music/Overworld.ogg")
	SceenTransition.ChangeSceen("res://Levels/FinalLevel.tscn")
