extends Enemy

enum{
	Angry,
	Waiting
}
var status = Waiting

var WallHits = 0

var player = null

var Velocity = Vector2.ZERO
var Gravity = 2500
var Pos = Vector2.ZERO
export var Speed = 400

func _ready():
	for member in get_tree().get_nodes_in_group("Player"):
		player = member
	print(player)
func _physics_process(delta):
	match status:
		Waiting:
			WallHits = 0
			$AnimatedSprite.play("Waiting")
		Angry:
			$AnimatedSprite.play("Angry")
			ChangeDir()
			if WallHits == 5:
				status = Waiting
	
	Velocity.y += Gravity * delta
	Velocity = move_and_slide(Velocity, Vector2.UP)


func ChangeDir():
	if is_on_wall():
		Velocity.x *= -1
		$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
		WallHits += 1
