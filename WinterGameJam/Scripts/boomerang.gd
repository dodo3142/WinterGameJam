extends KinematicBody2D

enum{
	Flying,
	ComingBack,
	Missed
}
var state = Flying

var Damage = 30
var candamage = true
#timer to fix boomerang stuck
onready var stuckTimer = $StuckTimer
export var StuckTime = 0.1
#to get the player and hand ref
onready var Player = get_parent()
var Hand = null
#movement variables
onready var Dir = position.direction_to(get_local_mouse_position())
export var rotationSpeed = 0.5
export var Speed = 300
export var Goaccl = 100
export var Backaccl = 100
export var Gravity = 250
onready var velocity = Vector2.ZERO


func _ready():
	#leave the player
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
			velocity = Dir * Speed
			if Speed <= 0:
				state = ComingBack
		ComingBack:
			Speed = Speed + Backaccl*delta
			velocity = position.direction_to(Hand.global_position)* Speed
		Missed:
			velocity.y = velocity.y + Gravity * delta
	
	
	var collision_info = move_and_collide(velocity * delta)
	#what to do when it collide
	if collision_info != null and state == Flying:
		Speed = 10
		state=ComingBack
	elif collision_info != null and state == ComingBack and stuckTimer.time_left == 0:
		stuckTimer.start(StuckTime)
	elif collision_info == null and state == ComingBack and stuckTimer.time_left > 0:
		stuckTimer.stop()
	elif collision_info != null and state == Missed:
		velocity.x = 0
		rotationSpeed = 0
		candamage = false




func _on_Area2D_area_entered(area):
	if candamage:
		if area.is_in_group("Enemy"):
			area.TakeDamage(Damage);
	
	if state == ComingBack:
		if area.is_in_group("Player"):
			state = Missed
	
	if area.is_in_group("Catch") && state != Flying:
		Player.BoomerangCount += 1
		queue_free()

func _on_StuckTimer_timeout():
	state= Missed
