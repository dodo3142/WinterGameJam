extends ParallaxLayer

export var CloudSpeed = -15

func _process(delta):
	self.motion_offset.x += CloudSpeed * delta
