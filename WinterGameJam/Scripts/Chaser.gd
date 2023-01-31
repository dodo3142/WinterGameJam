extends Enemy

var Velocity = Vector2.ZERO

var Gravity = 700
var Pos = Vector2.ZERO
var PlayerEntered = false
var Player = null

export var Speed = 200
export var TrackerSize = Vector2(80,30)

onready var ChaserSprite = $Sprite
onready var TrackerCollision = $PlayerTracker/CollisionShape2D

func _ready():
	TrackerCollision.scale = TrackerSize

func _process(_delta):
	if PlayerEntered:
		#player position
		Pos = position.direction_to(Player.global_position)

func _physics_process(delta):
	Velocity.y += Gravity * delta
	# Tracks player position and changes direction
	if Pos < Vector2.ZERO:
		ChaserSprite.flip_h = true
		Velocity.x = lerp(Velocity.x, -Speed, 0.09)
	else:
		ChaserSprite.flip_h = false
		Velocity.x = lerp(Velocity.x, Speed, 0.09)
		
	Velocity = move_and_slide(Velocity, Vector2.UP)


func _on_PlayerTracker_area_entered(area):
	if area.is_in_group("Player"):
		Player = area
		PlayerEntered = true


func _on_PlayerTracker_area_exited(area):
	if area.is_in_group("Player"):
		Player = null
		PlayerEntered = false
