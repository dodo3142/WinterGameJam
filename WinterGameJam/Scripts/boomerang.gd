extends RigidBody2D

onready var Player = get_parent()
export var rotationspeed = 10
var Goal = Vector2.ZERO
var IsComingBack = false


func _ready():
	#leave the player
	var root = get_tree().root
	var main_scene = root.get_child(root.get_child_count() - 1)
	position = Player.position
	get_parent().remove_child(self)
	main_scene.add_child(self)
	self.set_owner(main_scene)
	
	#go to it's goal
	var tween = get_node("Tween")
	tween.interpolate_property($".", "position", position, Goal, 0.5, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()


func _process(delta):
	#go back to the player
	if IsComingBack:
		var tween = get_node("Tween")
		tween.interpolate_property($".", "position", position, Player.global_position, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
		tween.start()

func _on_ComeBackTimer_timeout():
	IsComingBack = true



func _on_Area2D_area_entered(area):
	if IsComingBack:
		if area.is_in_group("Player"):
			queue_free()
