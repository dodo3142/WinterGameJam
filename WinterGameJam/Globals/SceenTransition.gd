extends CanvasLayer

var k

func ChangeSceen(NewSceen):
	$AnimationPlayer.play("Dissolve")
	yield($AnimationPlayer,"animation_finished")
	k=get_tree().change_scene(NewSceen)
	$AnimationPlayer.play_backwards("Dissolve")
