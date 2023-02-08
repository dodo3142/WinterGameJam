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
var Player = null
var checkright
var checkleft

export var WalkingSpeed = 200
export var ChasingSpeed = 400
export var AreaSize = 200
export var EndPositions = 200
export var RotationSpeed = 5.0

onready var ChaserSprite = $Sprite



func _ready():
	set_physics_process(false)
	PlayerDetectRadius = $PlayerDetect/CollisionShape2D
	#Gets starting position and inital velocity
	checkright = global_position.x + EndPositions
	checkleft = global_position.x - EndPositions
	Velocity.x = WalkingSpeed
	#Changes radius size of player detect
	PlayerDetectRadius.shape.radius = AreaSize
	

func _process(_delta):
	pass

func _physics_process(delta):
	match state:
		Walking:
			MatchSpeedToDir()
		Chasing:
			# Tracks player position and changes direction
			Velocity = position.direction_to(Player.global_position)* ChasingSpeed
			RotateToTarget(Player, delta)
		TakingDamage:
			pass
	
	
	Velocity = move_and_slide(Velocity, Vector2.UP)

#FOR WALKING State

func MatchSpeedToDir():
	if global_position.x >= checkright:
		Velocity.x = -WalkingSpeed
		ChaserSprite.flip_h = false
	elif global_position.x <= checkleft:
		Velocity.x = WalkingSpeed
		ChaserSprite.flip_h = true
	
#End Walking State

#Rotation logic
func RotateToTarget(target, delta):
	var Direction = (target.global_position - global_position)
	var AngleTo = ChaserSprite.transform.x.angle_to(Direction)
	ChaserSprite.rotate(sign(AngleTo) * min(delta * RotationSpeed, abs(AngleTo)))


func _on_PlayerDetect_area_entered(area):
	if area.is_in_group("Player"):
		state = Chasing
		Player = area
