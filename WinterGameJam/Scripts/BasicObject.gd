extends Area2D

var ActiveCol = '00ff76'
var DefualtCol = 'e20e0e'
var CompleteCol = '370ee2'
var Active = false

onready var sprite = $Sprite

func _ready():
	sprite.modulate = DefualtCol



func _on_BasicObject_area_entered(area):
	if area.is_in_group("Weapon"):
		sprite.modulate = ActiveCol
		Active = true
