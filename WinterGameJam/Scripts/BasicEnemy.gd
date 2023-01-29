extends KinematicBody2D
class_name Enemy

export var MaxHealth = 100
onready var Health = MaxHealth
onready var HealthText = $Health

func _ready():
	HealthText.text = Health as String

func _process(_delta):
	if Health <= 0:
		queue_free()

func TakeDamage(Damage):
	Health -= Damage
	HealthText.text = Health as String
