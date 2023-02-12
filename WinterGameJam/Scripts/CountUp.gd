extends Area2D

export var Amount = 1


func _on_CountUp_area_entered(area):
	if area.is_in_group("Player"):
		area.AddCount(Amount)
		Hud.BoomerangAmount += Amount
		queue_free()
