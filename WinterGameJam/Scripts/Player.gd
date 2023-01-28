extends KinematicBody2D

signal Grounded_Update(isGrounded)

enum PlayerState {GROUND, AIR, DAMAGE, DEAD}

export var Speed = 300
export var JumpForce=-800
export var FallGravity= 2500
export var JumpGravity = 2000
export var MaxFallSpeed = 800
export (float, 0, 1.0) var JumpStopMul = 0.7
export (float, 0, 1.0) var friction = 0.3
export (float, 0, 1.0) var acceleration = 0.3

var state = PlayerState.GROUND
var prev_state = PlayerState.GROUND

var canJump = false
var tryingtoJump= false
var isGrounded

var HorizontalDir = Vector2.ZERO
var velocity = Vector2.ZERO
onready var PlayerSprite = $Sprite
onready var CoyoteJump = $CoyoteTimer
onready var JumpBuffring = $JumpBuffring

func _process(delta):
	if is_on_floor():
		canJump = true
	elif(CoyoteJump.time_left <= 0):
		CoyoteJump.start()
	
	if HorizontalDir !=0:
		PlayerSprite.scale.x = HorizontalDir

func _physics_process(delta):
	Movement()
	Jumping()
	Gravity(delta)
	
	var wasGrounded = isGrounded
	isGrounded = is_on_floor()
	
	if wasGrounded == null || isGrounded != wasGrounded:
		emit_signal("Grounded_Update",isGrounded)
	print(velocity)
	
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
	HorizontalDir= Input.get_action_strength("Right")-Input.get_action_strength("Left")
	if HorizontalDir != 0:
		velocity.x = lerp(velocity.x, HorizontalDir * Speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

func Jumping():
	if Input.is_action_just_pressed("Jump"):
		tryingtoJump = true
		JumpBuffring.start()
	
	if tryingtoJump:
		if canJump:
			velocity.y = JumpForce
			canJump = false
	
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y = velocity.y * JumpStopMul
	
	if Input.is_action_just_released("Jump"):
		tryingtoJump = false

func Gravity(delta):
	if velocity.y >= 0 and velocity.y < MaxFallSpeed and !is_on_floor():
		velocity.y += FallGravity * delta
	elif velocity.y < 0:
		velocity.y += JumpGravity * delta

func _on_CoyoteTimer_timeout():
	canJump = false


func _on_JumpBuffring_timeout():
	tryingtoJump = false
