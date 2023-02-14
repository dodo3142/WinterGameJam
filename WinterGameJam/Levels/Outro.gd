extends Control



func _on_VideoPlayer_finished():
	MusicController.ChangeMusic(MusicController.MainMenu)
	SceenTransition.ChangeSceen("res://Levels/MainMenu.tscn")
