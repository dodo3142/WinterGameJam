extends KinematicBody2D

onready var Player = get_parent()
export var rotationspeed = 10
export var Xspeed = 400
export var Yspeed = 300
var velocity = Vector2.ZERO
var IsComingBack = false
var playerY
var playerX
var HorizontalDir


func _ready():
	#leave the player
	var root = get_tree().root
	var main_scene = root.get_child(root.get_child_count() - 1)
	position = Player.position
	get_parent().remove_child(self)
	main_scene.add_child(self)
	self.set_owner(main_scene)
	dir()
	print(HorizontalDir)
	

func _process(_delta):
	if Input.is_action_just_pressed("Attack"):
		IsComingBack = true


func _physics_process(_delta):
	playerY = Player.position.y
	playerX = Player.position.x
	
	velocity.y = move_and_slide(velocity, Vector2.UP).y
	if !IsComingBack:
		if HorizontalDir == 1:
			velocity.x = Xspeed
		elif HorizontalDir == -1:
			velocity.x = -Xspeed
	else:
		if self.position.x < playerX:
			self.velocity.x = Yspeed
		elif self.position.x > playerX:
			self.velocity.x = -Yspeed
		else:
			self.velocity.y = 0
		if self.position.y < playerY:
			self.velocity.y = Yspeed
		elif self.position.y > playerY:
			self.velocity.y = -Yspeed
		else:
			self.velocity.y = 0


func dir():
	#get input dir
	if Input.is_action_pressed("Right"):
		HorizontalDir = 1
	elif Input.is_action_pressed("Left"):
		HorizontalDir = -1
	else:
		HorizontalDir = 1


func _on_ComeBackTimer_timeout():
	IsComingBack = true


func _on_Area2D_area_entered(area):
	if IsComingBack:
		if area.is_in_group("Player"):
			queue_free()
			Player.create = true
