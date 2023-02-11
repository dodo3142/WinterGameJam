extends KinematicBody2D

signal Grounded_Update(isGrounded)

#Const
const FLASH_RATE = 0.05
const N_FLASHES = 4

#movement
export var Speed = 900
export var JumpForce=-1100
export var FallGravity= 3000
export var JumpGravity = 2000
export var MaxFallSpeed = 1200
export (float, 0, 1.0) var JumpStopMul = 0.7
export (float, 0, 1.0) var friction = 0.3
export (float, 0, 1.0) var acceleration = 0.3

#Boomerang Variables
export var BoomerangCount = 1
export var BoomerangJumpForce =-900
export var BoomrangPushDownForce = 400
export var ThrowForceTimeMult = 100
export var maxThrowForce = 2200
var PlayerColor = Color.white
var PulseColor = Color.lightyellow
var PulseColorHard = Color(1,1,0.5,1)
var BoomerangCanJumpOn = null
var ThrowForce = 0

#Damage
export var mindamage = 10
export var maxdamage = 30
export var DamageTimeMult = 20
var Damage = 10


#Health
export var MaxHealth = 200
onready var Health = MaxHealth
var Die = false

#boolens
var canmove = true
var canFlip =true
var canAttack = true
var JumpButtonrelesed = true
var canJump = false
var tryingtoJump= false
var takingDamage = false
var IsOnBoomerang = false
var isGrounded
var Landing

#Directions
var HorizontalDir = Vector2.ZERO
var Velocity = Vector2.ZERO
var k

#get the nodes and scenes
export(PackedScene) var FootstepsParticles
export(PackedScene) var LandParticles
onready var PlayerSprite = $PlayerSprite
onready var CoyoteJump = $CoyoteTimer
onready var JumpBuffring = $JumpBuffring
onready var AttackTimer = $AttackRate
onready var CatchTimer = $CatchTimer
onready var TakingDamageTimer = $TakingDamage
onready var Hand = $PlayerSprite/Hand/HandSprite
onready var RealHandPos = $PlayerSprite/Hand/RealHandPos
onready var HandBackPos = $PlayerSprite/Hand/HandBackPos
onready var CatchBox = $PlayerSprite/Hand/HandSprite/CatchHitBox/CollisionShape2D
onready var JumpCatchBox = $JumpCatchBox/CollisionShape2D
onready var PlayerEffects = $PlayerSprite/PlayerEffects
onready var GroundCheck = $GroundCheck
onready var PulseTween = $PulseTween
onready var FlashTween = $FlashTween
onready var Boomerang = preload("res://Scenes/boomerang.tscn")


func _ready():
	Health = MaxHealth
	set_physics_process(false)
	set_process(false)
	#Updates Heathbar to max health
	Hud.HealthBar._on_max_health_updated(MaxHealth)

func _process(_delta):
	#when player can jump
	if is_on_floor() or IsOnBoomerang:
		canJump = true
	elif(CoyoteJump.time_left <= 0):
		CoyoteJump.start()
	
	Throw(_delta)
	Catch()
	HandleParticles()
	
	Hud.BoomerangCount.text = str("x " + str(BoomerangCount))
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(delta):
	#move the player
	if canmove:
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
		if IsOnBoomerang:
				#BoomerangCanJumpOn.Velocity.y += BoomrangPushDownForce
				Velocity.y = BoomerangJumpForce
				JumpCatchBox.disabled = false
				CatchTimer.start()
		else:
				Velocity.y = JumpForce
		canJump = false
		AudioManager.play("res://Assets/SFX/Jump.wav")
	
	#variableJump
	if JumpButtonrelesed and Velocity.y < 0:
		Velocity.y = Velocity.y * JumpStopMul
		JumpButtonrelesed = false
	
	#JUMP&FALLING ANIMATION
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
	if Input.is_action_pressed("Attack")  && Hud.ThrowUpgrade && BoomerangCount > 0 and canAttack:
		Damage = Damage + DamageTimeMult * delta
		ThrowForce = ThrowForce + ThrowForceTimeMult * delta
		ThrowForce = clamp(ThrowForce,0,maxThrowForce)
		Damage = clamp(Damage,mindamage,maxdamage)
		Hand.position= lerp(Hand.position,HandBackPos.position,3*delta)
		#when fully charged, pulse chage color
		if ThrowForce == maxThrowForce:
			if !PulseTween.is_active():
				PulseTween.interpolate_property(PlayerSprite, "modulate", PlayerColor, PulseColorHard, 
				2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				PulseTween.start()
				FlashColor()
		else:
			PulseTween.set_active(false)
	else:
		Hand.position = lerp(Hand.position,RealHandPos.position,9*delta)
	if Input.is_action_just_released("Attack") && BoomerangCount > 0 and canAttack:
		canAttack = false
		AttackTimer.start()
		Hand.play("Throw")
		AudioManager.play("res://Assets/SFX/BoomerangThrow.wav")
		var b = Boomerang.instance()
		b.Damage = Damage as int
		b.ThrowForce = ThrowForce as int
		b.Hand = Hand
		add_child(b)
		BoomerangCount -= 1
		Damage = 10
		ThrowForce = 0
		PlayerSprite.modulate = PlayerColor
		PulseTween.set_active(false)

#catchingSystem
func Catch():
	if Input.is_action_just_pressed("Catch"):
		Hand.play("Catch")
		CatchBox.disabled = false
		CatchTimer.start()

#TakingDamageSystem
func TakeDamage(Amount):
	if !takingDamage and !Die:
		$PlayerSprite/Camera2D.add_trauma(0.2)
		Health -= Amount
		if Health <= 0:
			Hud.Die()
			Die = true
			PlayerSprite.visible = false
			canAttack = false
			set_physics_process(false)
			set_physics_process(false)
			AudioManager.play("res://Assets/SFX/PlayerDie_1.wav")
		PlayerEffects.play("Damage")
		FrameFreeze(0.05,0.4)
		TakingDamageTimer.start()
		takingDamage = true
		#Calls healthbar functions
		Hud.HealthBar._on_health_updated(Health, Health)
		AudioManager.play("res://Assets/SFX/PlayerDamage02.wav")

#Adds to boomerang count
func CountUp(Amount):
	BoomerangCount += Amount

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

#Flashs charge color
func FlashColor():
	for i in range(N_FLASHES * 2):
		#cant tell if color var works right? seems fine
		var color = PlayerSprite.modulate if i % 2 == 1 else PulseColor
		var time = FLASH_RATE * i + FLASH_RATE
		FlashTween.interpolate_callback(PlayerSprite, time, "set", "modulate", color)
	FlashTween.start()


#particles
func HandleParticles():
	if PlayerSprite.animation == "Running":
		if PlayerSprite.frame == 2 or PlayerSprite.frame == 7:
			var lastFrame = 0
			if lastFrame != PlayerSprite.frame:
				lastFrame = PlayerSprite.frame
				var footstep= FootstepsParticles.instance()
				if HorizontalDir < 0:
					footstep.scale.x *= -1
				footstep.emitting = true
				footstep.global_position = Vector2(global_position.x,global_position.y + 30)
				get_parent().add_child(footstep)
	if GroundCheck.is_colliding():
		if Landing:
			var LandParticle = LandParticles.instance()
			LandParticle.emitting = true
			LandParticle.global_position = Vector2(global_position.x,global_position.y + 30)
			get_parent().add_child(LandParticle)
			AudioManager.play("res://Assets/SFX/BoomerangHitGrass.wav")
			Landing = false
	else:
		if !Landing:
			Landing = true
#Timers
func _on_CoyoteTimer_timeout():
	canJump = false

func _on_JumpBuffring_timeout():
	tryingtoJump = false

func  _on_AttackRate_timeout():
	canAttack = true

func _on_CatchTimer_timeout():
	CatchBox.disabled = true
	JumpCatchBox.disabled = true

func _on_TakingDamage_timeout():
	takingDamage = false
	PlayerEffects.play("Off")

func _on_Timer_timeout():
	 set_process(true)
	 set_physics_process(true)
#TimersEnd

func _on_HandSprite_animation_finished():
	Hand.play("Idle")
