extends Area2D

export var Amount = 1


func _on_CountUp_area_entered(area):
	if area.is_in_group("Player"):
		for member in get_tree().get_nodes_in_group("Boomerang"):
			member.queue_free()
			area.AddCount(Amount)
		queue_free()
