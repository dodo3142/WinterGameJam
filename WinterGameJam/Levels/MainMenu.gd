extends Control

var k

func _ready():
	$Play.grab_focus()

func _process(delta):
		if Input.is_action_just_pressed("fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen

func _on_Play_pressed():
	MusicController.Play_Music()
	k = get_tree().change_scene("res://Levels/FeedBackLevel.tscn")

func _on_Quit_pressed():
	get_tree().quit()
