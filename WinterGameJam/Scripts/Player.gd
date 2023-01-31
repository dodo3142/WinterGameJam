extends KinematicBody2D

signal Grounded_Update(isGrounded)

#movement
export var Speed = 900
export var JumpForce=-1100
export var FallGravity= 3000
export var JumpGravity = 2000
export var MaxFallSpeed = 1200
export var BoomerangCount = 1
export (float, 0, 1.0) var JumpStopMul = 0.7
export (float, 0, 1.0) var friction = 0.3
export (float, 0, 1.0) var acceleration = 0.3

#Damage
export var mindamage = 10
export var maxdamage = 30
var Damage = 0

#Health
export var MaxHealth = 200
onready var Health = MaxHealth

#boolens
var canFlip =true
var canJump = false
var canAttack = true
var tryingtoJump= false
var JumpButtonrelesed = true
var isGrounded
var takingDamage = false

#Directions
var HorizontalDir = Vector2.ZERO
var Velocity = Vector2.ZERO

#get the nodes and scenes
onready var PlayerSprite = $PlayerSprite
onready var CoyoteJump = $CoyoteTimer
onready var JumpBuffring = $JumpBuffring
onready var CatchTimer = $CatchTimer
onready var AttackTimer = $AttackRate
onready var TakingDamageTimer = $TakingDamage
onready var Hand = $PlayerSprite/Hand/HandSprite
onready var CatchBox = $PlayerSprite/Hand/HandSprite/CatchHitBox/CollisionShape2D
onready var PlayerEffects = $PlayerSprite/PlayerEffects
onready var Boomerang = preload("res://Scenes/boomerang.tscn")


func _process(_delta):
	#when player can jump
	if is_on_floor():
		canJump = true
	elif(CoyoteJump.time_left <= 0):
		CoyoteJump.start()
	
	Throw(_delta)
	Catch()
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(delta):
	#move the player
	Movement()
	Jumping()
	Gravity(delta)
	Velocity = move_and_slide(Velocity,Vector2.UP)
	
	#give camera when is player is grounded
	CameraUpdate()
	
	#flip the player sprite
	if HorizontalDir != 0:
		if HorizontalDir == 1:
			PlayerSprite.scale.x = abs(PlayerSprite.scale.x)
		if HorizontalDir == -1:
			PlayerSprite.scale.x = -abs(PlayerSprite.scale.x)

#All Movement and Gravity
func Movement():
	#get input dir
	HorizontalDir = Input.get_action_strength("Right")-Input.get_action_strength("Left")
	#lerp velocity to get acceleration feel
	if HorizontalDir != 0:
		Velocity.x = lerp(Velocity.x, HorizontalDir * Speed, acceleration)
		if is_on_floor():
			PlayerSprite.play("Running")
	else:
		Velocity.x = lerp(Velocity.x, 0.0, friction)
		if is_on_floor():
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
	if tryingtoJump and canJump:
			Velocity.y = JumpForce
			canJump = false
	
	#variableJump
	if JumpButtonrelesed and Velocity.y < 0:
		Velocity.y = Velocity.y * JumpStopMul
		JumpButtonrelesed = false
		
	if !canJump and Velocity.y < 0:
		PlayerSprite.play("Jump")
	elif !canJump and Velocity.y > 0:
		PlayerSprite.play("Falling")

func Gravity(delta):
	#gravity whenfalling and when jumping 
	if Velocity.y >= 0 and Velocity.y < MaxFallSpeed and !is_on_floor():
		Velocity.y += FallGravity * delta
	elif Velocity.y < 0:
		Velocity.y += JumpGravity * delta
#All Movement and Gravity End

#ThrowingSystem
func Throw(delta):
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
#catchingSystem
func Catch():
	if Input.is_action_just_pressed("Catch"):
		Hand.play("Catch")
		CatchBox.disabled = false
		CatchTimer.start()

#TakingDamageSystem
func TakeDamage(Amount):
	if !takingDamage:
		Health -= Amount
		if Health <= 0:
			var k = get_tree().reload_current_scene()
		PlayerEffects.play("Damage")
		FrameFreeze(0.05,0.4)
		takingDamage = true
		TakingDamageTimer.start()
		print(Health)

#will slow the game to (timescale) for (duration)
func FrameFreeze(timescale,duration):
	Engine.time_scale = timescale
	yield(get_tree().create_timer(duration * timescale),"timeout")
	Engine.time_scale = 1

#CameraSystem(I will edit it later)
func CameraUpdate():
	var wasGrounded = isGrounded
	isGrounded = is_on_floor()
	if wasGrounded == null || isGrounded != wasGrounded:
		emit_signal("Grounded_Update",isGrounded)

#Timers
func _on_CoyoteTimer_timeout():
	canJump = false

func _on_JumpBuffring_timeout():
	tryingtoJump = false

func _on_CatchTimer_timeout():
	CatchBox.disabled = true

func _on_AttackRate_timeout():
	canAttack = true

func _on_TakingDamage_timeout():
	takingDamage = false
	PlayerEffects.play("Off")
#TimersEnd

func _on_HandSprite_animation_finished():
	Hand.play("Idle")
