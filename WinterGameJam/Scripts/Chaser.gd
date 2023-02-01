extends Enemy

enum{
	Chasing,
	Walking,
	TakingDamage
}
var state = Walking
enum FacingDir{
	Right,
	Left
}
export(FacingDir) var CurrentDir = FacingDir.Right


var Velocity = Vector2.ZERO
var Gravity = 700
var Pos = Vector2.ZERO
var PlayerEntered = false
var Player = null
var onLedge = false

export var WalkingSpeed = 200
export var ChasingSpeed = 400
export var CheckArea = 200

onready var ChaserSprite = $Sprite
onready var PlayerRightRaycast = $PlayerCheckRays/RightRayCast
onready var PlayerLeftRayCast = $PlayerCheckRays/LeftRayCast
onready var GroundRightRayCast = $GroundCheckRays/RightRayCast
onready var GroundLeftRayCast = $GroundCheckRays/LeftRayCast

func _ready():
	
	PlayerRightRaycast.cast_to.x = CheckArea
	PlayerLeftRayCast.cast_to.x = -CheckArea

func _process(_delta):
	if PlayerRightRaycast.is_colliding():
		Pos = position.direction_to(PlayerRightRaycast.get_collision_point())
		state = Chasing
	elif PlayerLeftRayCast.is_colliding():
		Pos = position.direction_to(PlayerLeftRayCast.get_collision_point())
		state = Chasing
	else:
		state = Walking

func _physics_process(delta):
	match state:
		Walking:
			onLedge = CheckIfOnLedge()
			MatchSpeedToDir()
		Chasing:
			# Tracks player position and changes direction
			if Pos < Vector2.ZERO:
				CurrentDir = FacingDir.Left
				Velocity.x = lerp(Velocity.x, -ChasingSpeed, 0.09)
				UpdateFacingDir()
			else:
				CurrentDir = FacingDir.Right
				Velocity.x = lerp(Velocity.x, ChasingSpeed, 0.09)
				UpdateFacingDir()
		TakingDamage:
			pass
	
	
	Velocity.y += Gravity * delta
	Velocity = move_and_slide(Velocity, Vector2.UP)

#FOR WALKING State
func CheckIfOnLedge():
	if !GroundRightRayCast.is_colliding() or !GroundRightRayCast.is_colliding():
		return true
	else:
		return false

func UpdateFacingDir():
	if(CurrentDir == FacingDir.Right):
		ChaserSprite.scale.x = abs(ChaserSprite.scale.x)
	else:
		ChaserSprite.scale.x = -abs(ChaserSprite.scale.x)

func MatchSpeedToDir():
	if(CurrentDir == FacingDir.Right):
		Velocity.x = WalkingSpeed
	else:
		Velocity.x = -WalkingSpeed
	
	if is_on_wall() or onLedge:
		if(CurrentDir == FacingDir.Right):
			position.x -= 10
			CurrentDir = FacingDir.Left
		else:
			position.x += 10
			CurrentDir = FacingDir.Right
	
	UpdateFacingDir()
#End Walking State
