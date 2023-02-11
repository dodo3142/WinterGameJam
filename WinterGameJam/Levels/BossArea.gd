extends Node2D



func _on_BossArea_area_entered(area):
	if area.is_in_group("Player"):
		$AnimationPlayer.play("BossStart")
