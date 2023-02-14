extends Control

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("Attack"):
		SceenTransition.ChangeSceen("res://Levels/FinalLevel.tscn")
		MusicController.ChangeMusic(MusicController.OverWorld)

func _on_VideoPlayer_finished():
	SceenTransition.ChangeSceen("res://Levels/FinalLevel.tscn")
	MusicController.ChangeMusic(MusicController.OverWorld)
