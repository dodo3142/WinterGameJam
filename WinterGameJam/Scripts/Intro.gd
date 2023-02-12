extends Control

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("Attack"):
		MusicController.ChangeMusic("res://Assets/Music/Overworld.ogg")
		SceenTransition.ChangeSceen("res://Levels/FinalLevel.tscn")

func _on_VideoPlayer_finished():
	MusicController.ChangeMusic("res://Assets/Music/Overworld.ogg")
	SceenTransition.ChangeSceen("res://Levels/FinalLevel.tscn")
