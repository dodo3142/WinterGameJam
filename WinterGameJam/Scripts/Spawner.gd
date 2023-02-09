extends Position2D

export (PackedScene) var SpawningScene

var CanSpawn = true

onready var VisEnabler = $VisibilityEnabler2D


func _ready():
	set_process(false)

func Spawn():
	if CanSpawn == true:
		var spawning = SpawningScene.instance()
		
		add_child(spawning)
		spawning.set_as_toplevel(true)
		spawning.global_position = global_position
		print("here")
		CanSpawn = false

func _on_VisibilityEnabler2D_screen_entered():
	if get_child_count() != 2:
		Spawn()

func _on_VisibilityEnabler2D_screen_exited():
	if get_child_count() <= 1:
		CanSpawn = true
