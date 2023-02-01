extends Enemy

enum{
	Chasing,
	Walking,
	TakingDamage
}
var state = Walking

var Velocity = Vector2.ZERO

var Gravity = 700
var Pos = Vector2.ZERO
var PlayerEntered = false
var Player = null

export var Speed = 200
export var CheckArea = 200

onready var ChaserSprite = $Sprite
onready var RightRaycast = $PlayerCheckRays/RightRayCast
onready var LeftRayCast = $PlayerCheckRays/LeftRayCast

func _ready():
	RightRaycast.cast_to.x = CheckArea
	LeftRayCast.cast_to.x = -CheckArea



func _process(_delta):
	if RightRaycast.is_colliding():
		Pos = position.direction_to(RightRaycast.get_collision_point())
		state = Chasing
	elif LeftRayCast.is_colliding():
		Pos = position.direction_to(LeftRayCast.get_collision_point())
		state = Chasing


func _physics_process(delta):
	match state:
		Walking:
			pass
		Chasing:
			# Tracks player position and changes direction
			if Pos < Vector2.ZERO:
				ChaserSprite.flip_h = true
				Velocity.x = lerp(Velocity.x, -Speed, 0.09)
			else:
				ChaserSprite.flip_h = false
				Velocity.x = lerp(Velocity.x, Speed, 0.09)
		TakingDamage:
			pass
	
	
	Velocity.y += Gravity * delta
	Velocity = move_and_slide(Velocity, Vector2.UP)
