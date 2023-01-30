extends KinematicBody2D
class_name Enemy

export var MaxHealth = 100
onready var Health = MaxHealth


func _ready():
	pass

func _process(_delta):
	if Health <= 0:
		queue_free()

func TakeDamage(Damage):
	Health -= Damage
	print(Damage)
