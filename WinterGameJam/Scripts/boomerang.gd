extends KinematicBody2D


export var Damage = 30

onready var Player = get_parent()
var Dir = 1
export var Speed = 300
export var Goaccl = 100
export var Backaccl = 100
var velocity = Vector2.ZERO
var IsComingBack = false


func _ready():
	#leave the player
	var root = get_tree().root
	var main_scene = root.get_child(root.get_child_count() - 1)
	position = Player.position
	get_parent().remove_child(self)
	main_scene.add_child(self)
	self.set_owner(main_scene)

func _process(_delta):
	rotate(0.5)

func _physics_process(delta):
	if IsComingBack == false:
		Speed = Speed - Goaccl*delta
		velocity.x = Dir*Speed
		if Speed <= 0:
			IsComingBack = true
	elif IsComingBack == true:
		Speed = Speed + Backaccl*delta
		velocity = position.direction_to(Player.position)* Speed
	
	velocity = move_and_slide(velocity,Vector2.UP)



func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		area.TakeDamage(Damage);
	
	if IsComingBack:
		if area.is_in_group("Player"):
			queue_free()
