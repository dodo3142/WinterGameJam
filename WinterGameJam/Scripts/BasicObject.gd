extends Area2D

var Active = false

onready var sprite = $Sprite
var OFFsprite = preload("res://Assets/Off.png")
var ONsprite = preload("res://Assets/aCTIVATED.png")

func _ready():
	sprite.set_texture(OFFsprite)

func _on_BasicObject_area_entered(area):
	if area.is_in_group("Weapon"):
		sprite.set_texture(ONsprite)
		Active = true
