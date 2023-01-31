extends Position2D

onready var HandSprite = $HandSprite

var StickCord = Vector2.LEFT
var PreviousCord

func _process(_delta):
	#Mouse Rotation
	look_at(get_global_mouse_position())
	
	#To clamp the rotationdegrees
	if rotation_degrees >= 360:
		rotation_degrees = 0
	if rotation_degrees <= -360:
		rotation_degrees = 0
	
	#ToFlipTheHandSprite
	if rotation_degrees >= 90 and rotation_degrees < 270 or rotation_degrees >= -270 and rotation_degrees < -90:
		HandSprite.flip_v = true
	else:
		HandSprite.flip_v = false
	
	#Controller()


func Controller():
	#Controller Rotation
	var Dir = Vector2(Input.get_action_strength("HandRight") - Input.get_action_strength("HandLeft"), Input.get_action_strength("HandDown") - Input.get_action_strength("HandUp"))
	
	if abs(Dir.x) > 0.1 or abs(Dir.y) > 0.1:
		StickCord = Dir.normalized()
		print(StickCord)
	elif PreviousCord != null:
		StickCord = PreviousCord
	
	PreviousCord = StickCord
	
	var indicator_pos = 85 * StickCord
	HandSprite.position = lerp(HandSprite.position, indicator_pos, 0.45)
	HandSprite.rotation = StickCord.angle()
