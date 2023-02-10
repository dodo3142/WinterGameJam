extends CanvasLayer

onready var HealthBar = $HealthBar
onready var BoomerangCount = $Sprite/Label
export var ThrowUpgrade = false
export var JumpUpgrade = false
var k

func Die():
	$AnimationPlayer.play("Die")

func _on_Button_pressed():
	$AnimationPlayer.play_backwards("Die")
	k = get_tree().reload_current_scene()
