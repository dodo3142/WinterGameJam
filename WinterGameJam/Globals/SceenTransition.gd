extends CanvasLayer

func ChangeSceen(NewSceen):
	$AnimationPlayer.play("Dissolve")
	yield($AnimationPlayer,"animation_finished")
	get_tree().change_scene(NewSceen)
	$AnimationPlayer.play_backwards("Dissolve")
