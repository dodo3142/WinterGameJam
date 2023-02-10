extends StaticBody2D

export var Attack = 30

func _on_HitBox_area_entered(area):
		if area.is_in_group("Player"):
			area.TakeDamage(Attack)
