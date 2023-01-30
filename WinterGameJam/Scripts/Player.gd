extends KinematicBody2D

signal Grounded_Update(isGrounded)

#movement
export var Speed = 300
export var JumpForce=-800
export var FallGravity= 2500
export var JumpGravity = 2000
export var MaxFallSpeed = 800
export var BoomerangCount = 1
export (float, 0, 1.0) var JumpStopMul = 0.7
export (float, 0, 1.0) var friction = 0.3
export (float, 0, 1.0) var acceleration = 0.3

export var mindamage = 10
export var maxdamage = 30
var Damage = 0

#boolens
var canFlip =true
var canJump = false
var canAttack = true
var tryingtoJump= false
var JumpButtonrelesed = true
var isGrounded

#Directions
var HorizontalDir = Vector2.ZERO
var velocity = Vector2.ZERO

#get the nodes and scenes
onready var PlayerSprite = $PlayerSprite
onready var CoyoteJump = $CoyoteTimer
onready var JumpBuffring = $JumpBuffring
onready var CatchTimer = $CatchTimer
onready var AttackTimer = $AttackRate
onready var Hand = $PlayerSprite/Hand/HandSprite
onready var CatchBox = $PlayerSprite/Hand/HandSprite/CatchHitBox/CollisionShape2D
onready var Boomerang = preload("res://Scenes/boomerang.tscn")

func _process(_delta):
	#when player can jump
	if is_on_floor():
		canJump = true
	elif(CoyoteJump.time_left <= 0):
		CoyoteJump.start()
	
	Attack(_delta)
	Catch()



func _physics_process(delta):
	#move the player
	Movement()
	Jumping()
	Gravity(delta)
	velocity = move_and_slide(velocity,Vector2.UP)
	
	#give camera when is player is grounded
	CameraUpdate()
	
	#flip the player sprite
	if HorizontalDir != 0:
		if HorizontalDir == 1:
			PlayerSprite.scale.x = abs(PlayerSprite.scale.x)
		if HorizontalDir == -1:
			PlayerSprite.scale.x = -abs(PlayerSprite.scale.x)



func Movement():
	#get input dir
	HorizontalDir = Input.get_action_strength("Right")-Input.get_action_strength("Left")
	#lerp velocity to get acceleration feel
	if HorizontalDir != 0:
		velocity.x = lerp(velocity.x, HorizontalDir * Speed, acceleration)
		PlayerSprite.play("Running")
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		PlayerSprite.play("Idle")

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

func Attack(delta):
	if Input.is_action_pressed("Attack") && BoomerangCount > 0 and canAttack:
		Damage = Damage + mindamage*delta
		Damage = clamp(Damage,mindamage,maxdamage)
	if Input.is_action_just_released("Attack") && BoomerangCount > 0 and canAttack:
		canAttack = false 
		AttackTimer.start()
		Hand.play("Throw")
		var b = Boomerang.instance()
		b.Damage = Damage as int
		b.Hand = Hand
		add_child(b)
		BoomerangCount -= 1
		Damage = 0

func Catch():
	if Input.is_action_just_pressed("Throw"):
		Hand.play("Catch")
		CatchBox.disabled = false
		CatchTimer.start()

func Gravity(delta):
	#gravity whenfalling and when jumping 
	if velocity.y >= 0 and velocity.y < MaxFallSpeed and !is_on_floor():
		velocity.y += FallGravity * delta
	elif velocity.y < 0:
		velocity.y += JumpGravity * delta

func CameraUpdate():
	var wasGrounded = isGrounded
	isGrounded = is_on_floor()
	if wasGrounded == null || isGrounded != wasGrounded:
		emit_signal("Grounded_Update",isGrounded)

func _on_CoyoteTimer_timeout():
	canJump = false

func _on_JumpBuffring_timeout():
	tryingtoJump = false

func _on_CatchTimer_timeout():
	CatchBox.disabled = true

func _on_AttackRate_timeout():
	canAttack = true
