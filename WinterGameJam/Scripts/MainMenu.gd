extends Control

var k

func _ready():
	MusicController.Play_Music()
	$Play.grab_focus()
	Hud.visible=false

func _process(_delta):
		if Input.is_action_just_pressed("fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen

func _on_Play_pressed():
	MusicController.ChangeMusic("res://Assets/Music/OverwolrdDemo3.ogg")
	SceenTransition.ChangeSceen("res://Levels/FinalLevel.tscn")

func _on_Quit_pressed():
	get_tree().quit()
