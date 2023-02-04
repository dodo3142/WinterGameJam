extends Node2D

func _process(_delta):
	CheckSwitch()

var list = []

onready var door = $Door

func _ready():
	#var Switch = get_child_count()
	for i in get_children():
		if i.is_in_group("Object"):
			list.append(i)


func CheckSwitch():
	# gets all object children and checks if activated
	#var Switch = get_child_count()
	for i in get_children():
		if i.is_in_group("Object"):
		# if activated remove i from list
			if i.Active:
				list.erase(i)
			#Switch -= 1
	if list.size() == 0:
		for i in get_children():
			if i.is_in_group("Object"):
				i.sprite.modulate = i.CompleteCol
				door.Deactivate()
