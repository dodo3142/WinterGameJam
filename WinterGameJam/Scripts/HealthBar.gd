extends Control

const FLASH_RATE = 0.05
const N_FLASHES = 4

onready var HealthOver = $HealthOver
onready var HealthUnder = $HealthUnder
onready var UpdateTween = $UpdateTween
onready var PulseTween = $PulseTween
onready var FlashTween = $FlashTween

export (Color) var HealthyColor = Color.green
export (Color) var CautionColor = Color.yellow
export (Color) var DangerColor = Color.red
export (Color) var PulseColor = Color.darkred
export (Color) var FlashColor = Color.orangered
export (float, 0, 1, 0.05) var CautionZone = 0.5
export (float, 0, 1, 0.05) var DangerZone = 0.2
export (bool) var WillPulse = false

#updates health
func _on_health_updated(health, amount):
	HealthOver.value = health
	print(HealthOver.value)
	UpdateTween.interpolate_property(HealthUnder, "value", HealthUnder.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	UpdateTween.start()
	
	# assigns color of health bar
	_assign_color(health)
	#Not sure what amount should be honestly but it works :\
	if amount < 0:
		_flash_damage()

#Assigns healthbar color to how low health value is
func _assign_color(health):
	if health == 0:
		PulseTween.set_active(false)
	elif health < HealthOver.max_value * DangerZone:
		if WillPulse:
			if !PulseTween.is_active():
				PulseTween.interpolate_property(HealthOver, "tint_progress", PulseColor, DangerColor, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
				PulseTween.start()
		else:
			HealthOver.tint_progress = DangerColor
	else:
		PulseTween.set_active(false)
		if health < HealthOver.max_value * CautionZone:
			HealthOver.tint_progress = CautionColor
		else:
			HealthOver.tint_progress = HealthyColor

#Flashs healthbar when low
func _flash_damage():
	for i in range(N_FLASHES * 2):
		#cant tell if color var works right? seems fine
		var color = HealthOver.tint_progress if i % 2 == 1 else FlashColor
		var time = FLASH_RATE * i + FLASH_RATE
		FlashTween.interpolate_callback(HealthOver, time, "set", "tint_progress", color)
	FlashTween.start()

#sets maxhealth health to equal max health
func _on_max_health_updated(max_health):
	HealthOver.max_value = max_health
	HealthUnder.max_value = max_health
	HealthOver.value = max_health
	HealthUnder.value = max_health
	
