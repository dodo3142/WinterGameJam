extends Control

func _ready():
	$VBoxContainer/Play.grab_focus()
func _process(delta):
		if Input.is_action_just_pressed("fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen

func _on_Play_pressed():
	get_tree().change_scene("res://Levels/FeedBackLevel.tscn")


func _on_Quit_pressed():
	get_tree().quit()
