extends Enemy

var Direction = Vector2.LEFT
var Velocity = Vector2.ZERO

onready var Raycast = $RayCast2D

func _ready():
	#set_physics_process(false)
	pass

func _physics_process(delta: float) -> void:
	#Velocity.y += Gravity * delta
	#if touch wall/raycast dosent touch floor mulitply by -1 to change direction
	if is_on_wall() || !Raycast.is_colliding():
		Direction *= -1
		Raycast.position.x *= -1
	Velocity = Direction * 2500
	move_and_slide(Velocity, Vector2.UP)

