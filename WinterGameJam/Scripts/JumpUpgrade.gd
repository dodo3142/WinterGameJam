extends Area2D

func _on_JumpUpgrade_area_entered(area):
	if area.is_in_group("Player"):
		Hud.JumpUpgrade = true
		queue_free()
