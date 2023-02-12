extends Area2D

export var Amount = 1

onready var sprite = $Sprite

func _on_CheckPoint_area_entered(area):
	if area.is_in_group("Player"):
		for member in get_tree().get_nodes_in_group("Boomerang"):
			member.queue_free()
			area.AddCount(Amount)
	Hud.PlayerPos = position
	sprite.play("Activated")


func _on_Sprite_animation_finished():
	if sprite.animation == 'Activated':
		sprite.play("Idle")
