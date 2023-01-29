extends Position2D

onready var HandSprite = $HandSprite

func _process(delta):
	look_at(get_global_mouse_position())
	
	if rotation_degrees >= 360:
		rotation_degrees = 0
	if rotation_degrees <= -360:
		rotation_degrees = 0
	
	if rotation_degrees >= 90 and rotation_degrees < 270 or rotation_degrees >= -270 and rotation_degrees < -90:
		HandSprite.flip_v = true
	else:
		HandSprite.flip_v = false

