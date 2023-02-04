extends StaticBody2D

onready var DoorSprite = $Sprite
onready var Collision = $CollisionShape2D

func Deactivate():
	DoorSprite.visible = false
	Collision.disabled = true
