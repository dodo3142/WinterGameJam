extends KinematicBody2D
class_name Enemy

export var MaxHealth = 100
export var Attack = 30
export var FrameFreezeTime = 0.2
onready var Health = MaxHealth


func _ready():
	pass

func _process(_delta):
	if Health <= 0:
		queue_free()
		Engine.time_scale = 1

func TakeDamage(Damage):
	Health -= Damage
	FrameFreeze(FrameFreezeTime)
	print(Damage)

func FrameFreeze(duration):
	set_process(false)
	set_physics_process(false)
	yield(get_tree().create_timer(duration),"timeout")
	set_process(true)
	set_physics_process(true)

func _on_HitBox_area_entered(area):
		if area.is_in_group("Player"):
			area.TakeDamage(Attack)
