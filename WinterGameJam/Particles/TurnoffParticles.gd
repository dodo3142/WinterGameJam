extends Particles2D

export var TimeToDie = 0.5

func _ready():
	yield(get_tree().create_timer(TimeToDie),"timeout")
	queue_free()
