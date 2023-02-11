extends CanvasLayer

onready var HealthBar = $HealthBar
onready var BoomerangCount = $Sprite/Label
export var ThrowUpgrade = false
export var JumpUpgrade = false
var PlayerPos = Vector2.ZERO
var k

func Die():
	$AnimationPlayer.play("Die")

func Pause():
	$PauseMenu.visible = true
	get_tree().paused = true

func _on_Button_pressed():
	$AnimationPlayer.play_backwards("Die")
	k = get_tree().reload_current_scene()

func _on_Resume_pressed():
	$PauseMenu.visible = false
	get_tree().paused = false

func _on_Quit_pressed():
	get_tree().quit()
