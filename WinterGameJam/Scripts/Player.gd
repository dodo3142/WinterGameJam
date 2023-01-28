extends KinematicBody2D

signal Grounded_Update(isGrounded)

enum PlayerState {GROUND, AIR, DAMAGE, DEAD}

#movement
export var Speed = 300
export var JumpForce=-800
export var FallGravity= 2500
export var JumpGravity = 2000
export var MaxFallSpeed = 800
export (float, 0, 1.0) var JumpStopMul = 0.7
export (float, 0, 1.0) var friction = 0.3
export (float, 0, 1.0) var acceleration = 0.3

#states
var state = PlayerState.GROUND
var prev_state = PlayerState.GROUND

#boolens
var canJump = false
var tryingtoJump= false
var JumpButtonrelesed = true
var isGrounded

#Directions
var HorizontalDir = Vector2.ZERO
var velocity = Vector2.ZERO

#get the nodes and scenes
onready var PlayerSprite = $Sprite
onready var CoyoteJump = $CoyoteTimer
onready var JumpBuffring = $JumpBuffring
onready var Boomerang = preload("res://Scenes/boomerang.tscn")

func _process(delta):
	#when player can jump
	if is_on_floor():
		canJump = true
	elif(CoyoteJump.time_left <= 0):
		CoyoteJump.start()
	#flip playersprite when changing dir
	if HorizontalDir !=0:
		PlayerSprite.scale.x = HorizontalDir
	
	if Input.is_action_just_pressed("Attack"):
		var b = Boomerang.instance()
		var BoomGoal = $Sprite/BoomerangGoal.global_position
		b.Goal = BoomGoal
		add_child(b)


func _physics_process(delta):
	Movement()
	Jumping()
	Gravity(delta)
	
	#give camera when is player is grounded
	var wasGrounded = isGrounded
	isGrounded = is_on_floor()
	if wasGrounded == null || isGrounded != wasGrounded:
		emit_signal("Grounded_Update",isGrounded)
	
	#move the player
	velocity = move_and_slide(velocity,Vector2.UP)
	
	# state machine
	match state:
		PlayerState.GROUND:
			pass

		PlayerState.AIR:
			pass

# change state logic
func change_state(new_state):
	prev_state = state
	state = new_state

func Movement():
	#get input dir
	HorizontalDir= Input.get_action_strength("Right")-Input.get_action_strength("Left")
	#lerp velocity to get acceleration feel
	if HorizontalDir != 0:
		velocity.x = lerp(velocity.x, HorizontalDir * Speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

func Jumping():
	
	#start jump buffring when player press jump
	if Input.is_action_just_pressed("Jump"):
		JumpButtonrelesed = false
		tryingtoJump = true
		JumpBuffring.start()
	
	#get wen player relese JumpButton
	if Input.is_action_just_released("Jump"):
		JumpButtonrelesed = true
	
	#jumping
	if tryingtoJump:
		if canJump:
			velocity.y = JumpForce
			canJump = false
	
	#variableJump
	if JumpButtonrelesed and velocity.y < 0:
		velocity.y = velocity.y * JumpStopMul
		JumpButtonrelesed = false


func Gravity(delta):
	#gravity whenfalling and when jumping 
	if velocity.y >= 0 and velocity.y < MaxFallSpeed and !is_on_floor():
		velocity.y += FallGravity * delta
	elif velocity.y < 0:
		velocity.y += JumpGravity * delta

func _on_CoyoteTimer_timeout():
	canJump = false


func _on_JumpBuffring_timeout():
	tryingtoJump = false

#put Boomerang every beat
#func _on_BeatTimer_timeout():
#	var b = Boomerang.instance()
#	var BoomGoal = $Sprite/BoomerangGoal.global_position
#	b.Goal = BoomGoal
#	add_child(b)
