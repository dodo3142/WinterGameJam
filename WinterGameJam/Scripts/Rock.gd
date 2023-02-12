extends KinematicBody2D
export var Gravity = 700
var Velocity = Vector2.ZERO
export var Attack = 30

func _process(delta):
	if $AnimatedSprite.animation != "Hit":
		rotate(0.1)
	if $RayCast2D.is_colliding():
		$AnimatedSprite.play("Hit")

func _physics_process(delta):
	Velocity.y += Gravity * delta
	Velocity = move_and_slide(Velocity, Vector2.UP)

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		area.TakeDamage(Attack)
		$AnimatedSprite.play("Hit")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Hit":
		yield(get_tree().create_timer(0.2),"timeout")
		queue_free()
