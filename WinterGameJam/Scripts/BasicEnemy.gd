extends KinematicBody2D
class_name Enemy

export var MaxHealth = 100
export var Attack = 30
onready var Health = MaxHealth


func _ready():
	pass

func _process(_delta):
	if Health <= 0:
		queue_free()
		Engine.time_scale = 1

func TakeDamage(Damage):
	Health -= Damage
	FrameFreeze(0.05,0.2)
	print(Damage)

func FrameFreeze(timescale,duration):
	Engine.time_scale = timescale
	yield(get_tree().create_timer(duration * timescale),"timeout")
	Engine.time_scale = 1

func _on_HitBox_area_entered(area):
		if area.is_in_group("Player"):
			area.TakeDamage(Attack)
