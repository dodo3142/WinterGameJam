extends KinematicBody2D

#States
enum{
	Flying,
	ComingBack,
	Missed
}
var state = Flying

#Boomerang Movement
export var rotationSpeed = 0.5
export var Speed = 300
export var Goaccl = 100
export var Backaccl = 100
export var Gravity = 250
onready var Dir = position.direction_to(get_local_mouse_position())
onready var Velocity = Vector2.ZERO
var ThrowForce = 0

#Damage
var FrameFreezeTime = 0.2
var Damage = 0
var candamage = true
export(PackedScene) var HitParticles
onready var AudioHitGrass = $HitGrass
onready var AudioHitEnemy = $HitEnemy

#timer to fix boomerang stuck and collide
onready var CollideTimer = $CollideTimer
var canCollide = false
onready var stuckTimer = $StuckTimer
export var StuckTime = 0.1

#to get the player and hand ref
onready var Player = get_parent()
var Hand = null

func _ready():
	Speed = Speed + ThrowForce
	#print(Speed)
	LeaveThePlayer()

#LeaveThePlayer
func LeaveThePlayer():
	var root = get_tree().root
	var main_scene = root.get_child(root.get_child_count() - 1)
	position = Hand.global_position
	get_parent().remove_child(self)
	main_scene.add_child(self)
	self.set_owner(main_scene)

func _process(_delta):
	#rotation effect
	rotate(rotationSpeed)

func _physics_process(delta):
	#state machine
	match state:
		Flying:
			Speed = Speed - Goaccl * delta
			Velocity = Dir * Speed
			if Speed <= 0:
				state = ComingBack
		ComingBack:
			Speed = Speed + Backaccl * delta
			Velocity = position.direction_to(Hand.global_position)* Speed
		Missed:
			Velocity.y = Velocity.y + 1000 * delta
	
	var collision_info = move_and_collide(Velocity * delta)
	
	if canCollide:
		CollisionCheck(collision_info)

#what to do when it collide
func CollisionCheck(collision_info):
	if collision_info != null and state == Flying:
		Speed = Speed / 4
		state=ComingBack
		AudioHitGrass.play()
	elif collision_info != null and state == ComingBack and stuckTimer.time_left == 0:
		stuckTimer.start(StuckTime)
		AudioHitGrass.play()
	elif collision_info == null and state == ComingBack and stuckTimer.time_left > 0:
		stuckTimer.stop()
	elif collision_info != null and state == Missed:
		Velocity.x = 0
		rotationSpeed = 0
		candamage = false

func _on_Area2D_area_entered(area):
	#to damage the enemy
	if candamage:
		if area.is_in_group("Enemy"):
			area.TakeDamage(Damage)
			FrameFreeze(FrameFreezeTime)
			var HitParticle = HitParticles.instance()
			HitParticle.emitting = true
			HitParticle.global_position = Vector2(global_position.x,global_position.y)
			get_parent().add_child(HitParticle)
			AudioHitEnemy.play()
	#to get when it should be Missed
	if state == ComingBack:
		if area.is_in_group("Player") or area.is_in_group("PlayerHand"):
			state = Missed
	#To get when it is caught by the player
	if area.is_in_group("Catch"):
		AudioManager.play("res://Assets/SFX/BoomerangCatch.wav")
		Player.BoomerangCount += 1
		Player.IsOnBoomerang = false
		queue_free()
	
	if area.is_in_group("Player") and candamage && Hud.JumpUpgrade:
		Player.IsOnBoomerang = true
		Player.BoomerangCanJumpOn = self

func _on_Area2D_area_exited(area):
	if Hud.JumpUpgrade && area.is_in_group("Player"):
		Player.IsOnBoomerang = false
		Player.BoomerangCanJumpOn = null

func FrameFreeze(duration):
	#set_process(false)
	set_physics_process(false)
	yield(get_tree().create_timer(duration),"timeout")
	#set_process(true)
	set_physics_process(true)

func _on_StuckTimer_timeout():
	state= Missed

func _on_CollideTimer_timeout():
	canCollide = true
