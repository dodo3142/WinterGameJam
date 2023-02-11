extends StaticBody2D


export var center = false

onready var oneway = $Sprite

func _ready():
	if center:
		oneway.animation = "Center"
	else:
		oneway.animation = "Ends"
