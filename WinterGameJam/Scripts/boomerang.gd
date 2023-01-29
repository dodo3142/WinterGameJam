extends KinematicBody2D

enum{
	Flying,
	ComingBack,
	Missed
}
var state = Flying

export var Damage = 30

onready var Player = get_parent()
var Hand = null
onready var Dir = position.direction_to(get_local_mouse_position())
export var rotationSpeed = 0.5
export var Speed = 300
export var Goaccl = 100
export var Backaccl = 100
export var Missiedaccl = 200
export var Gravity = 250
var velocity = Vector2.ZERO
var IsComingBack = false


func _ready():
	#leave the player
	var root = get_tree().root
	var main_scene = root.get_child(root.get_child_count() - 1)
	position = Hand.global_position
	get_parent().remove_child(self)
	main_scene.add_child(self)
	self.set_owner(main_scene)

func _process(_delta):
	
	rotate(rotationSpeed)

func _physics_process(delta):
	match state:
		Flying:
			Speed = Speed - Goaccl*delta
			velocity = Dir*Speed
			if Speed <= 0:
				state = ComingBack
		ComingBack:
			Speed = Speed + Backaccl*delta
			velocity = position.direction_to(Hand.global_position)* Speed
		Missed:
			velocity.y = velocity.y + Gravity * delta
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info != null and state == Flying:
		state=ComingBack
	elif collision_info != null and state == Missed:
		velocity.x = 0
		rotationSpeed = 0




func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		area.TakeDamage(Damage);
	
	if state == ComingBack:
		if area.is_in_group("Player"):
			state = Missed
