extends KinematicBody2D

onready var Player = get_parent()
export var rotationspeed = 10
export var Xspeed = 400
export var Yspeed = 300
var velocity = Vector2.ZERO
var IsComingBack = false
var playerY


func _ready():
	#leave the player
	var root = get_tree().root
	var main_scene = root.get_child(root.get_child_count() - 1)
	position = Player.position
	get_parent().remove_child(self)
	main_scene.add_child(self)
	self.set_owner(main_scene)
	

func _process(_delta):
	if Input.is_action_just_pressed("Attack"):
		IsComingBack = true


func _physics_process(_delta):
	playerY = Player.position.y
	
	velocity.y = move_and_slide(velocity, Vector2.UP).y
	if !IsComingBack:
		velocity.x = Xspeed
	else:
		velocity.x = -Xspeed
		if self.position.y < playerY:
			self.velocity.y = Yspeed
		elif self.position.y > playerY:
			self.velocity.y = -Yspeed
		else:
			self.velocity.y = 0


func _on_ComeBackTimer_timeout():
	IsComingBack = true


func _on_Area2D_area_entered(area):
	if IsComingBack:
		if area.is_in_group("Player"):
			queue_free()
			Player.create = true
