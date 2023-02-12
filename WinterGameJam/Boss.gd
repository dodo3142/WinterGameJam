extends Enemy

enum{
	Angry,
	Waiting
}
var status = Waiting

var WallHits = 0
var canPlay = true
var PlayerCamera = null

var Velocity = Vector2.ZERO
var Gravity = 2500
var Pos = Vector2.ZERO
export var MaxSpeed = 800
var checkwall = true
export(PackedScene) var RockSceen

func _ready():
	for members in get_tree().get_nodes_in_group("PlayerCamera"):
		PlayerCamera = members
	
func _physics_process(delta):
	if canPlay:
		MusicController.ChangeMusic("res://Assets/Music/04 Boss.ogg")
		canPlay = false
	match status:
		Waiting:
			if $RookSpawnTimer.time_left >0:
				pass
			else:
				$RookSpawnTimer.start()
			if ($WaitTime.time_left > 0):
				pass
			else:
				$WaitTime.start()
			WallHits = 0
			$AnimatedSprite.play("Waiting")
		Angry:
			$AnimatedSprite.play("Angry")
			Velocity.x = lerp(Velocity.x,MaxSpeed,0.1)
			ChangeDir()
			if WallHits == 5:
				status = Waiting
	
	Velocity.y += Gravity * delta
	Velocity = move_and_slide(Velocity, Vector2.UP)


func ChangeDir():
	if is_on_wall() and checkwall:
		checkwall = false
		$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
		if $AnimatedSprite.flip_h == false:
			$Path2D.scale.x = -1
			$HitBox.scale.x = -1
		else:
			$Path2D.scale.x = 1
			$HitBox.scale.x = 1
		WallHits += 1
		PlayerCamera.add_trauma(0.5)
		AudioManager.play("res://Assets/SFX/RunOnGravel01.wav")
		yield(get_tree().create_timer(0.5),"timeout")
		MaxSpeed *= -1
		yield(get_tree().create_timer(0.5),"timeout")
		checkwall = true


func _on_WaitTime_timeout():
	status = Angry


func _on_RookSpawnTimer_timeout():
	var Rock = RockSceen.instance()
	var RockSpawnLocation = $Path2D/RookSpawnLoc
	RockSpawnLocation.offset = randi()
	Rock.global_position = RockSpawnLocation.global_position
	get_parent().add_child(Rock)
	print("hi")
