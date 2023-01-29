extends Node2D

func _process(_delta):
	CheckSwitch()


func CheckSwitch():
	# gets all objects children and checks if activated
	var Switch = get_child_count()
	for i in get_children():
		# if activated remove from i
		if i.Active:
			Switch -= 1
	if Switch == 0:
		for i in get_children():
			i.sprite.modulate = i.CompleteCol
