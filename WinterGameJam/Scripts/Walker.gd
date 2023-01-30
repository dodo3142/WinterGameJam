extends Enemy

export var Speed = 200

var Direction = Vector2.LEFT
var Velocity = Vector2.ZERO
var Gravity = 700

onready var Raycast = $RayCast2D

func _ready():
	#set_physics_process(false)
	Velocity.x = Speed

func _physics_process(delta: float) -> void:
	Velocity.y += Gravity * delta
	#if touch wall/raycast dosent touch floor mulitply by -1 to change direction
	if is_on_wall() || !Raycast.is_colliding():
		Velocity.x *= -1
		Raycast.position.x *= -1
	Velocity.y = move_and_slide(Velocity, Vector2.UP).y

