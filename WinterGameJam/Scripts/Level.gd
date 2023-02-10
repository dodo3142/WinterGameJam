extends Node2D

var k

func _ready():
	Engine.time_scale=1
	Hud.visible=true

func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("reset"):
		k = get_tree().reload_current_scene()
	if Input.is_action_just_pressed("ui_cancel"):
		Hud.Pause()
	
