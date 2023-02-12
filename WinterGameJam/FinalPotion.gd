extends KinematicBody2D

var Velocity = Vector2.ZERO
var Gravity = 2500

func _physics_process(delta):
	Velocity.y += Gravity * delta
	Velocity = move_and_slide(Velocity, Vector2.UP)

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		Hud.visible = false
		MusicController.ChangeMusic("res://Assets/Music/Outro Cutscene.wav")
		SceenTransition.ChangeSceen("res://Levels/Outro.tscn")
