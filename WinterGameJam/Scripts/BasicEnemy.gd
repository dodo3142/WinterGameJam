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

func TakeDamage(Damage):
	Health -= Damage
	print(Damage)


func _on_HitBox_area_entered(area):
		if area.is_in_group("Player"):
			area.TakeDamage(Attack)
