extends Area2D

func TakeDamage(Damage):
	owner.TakeDamage(Damage)

func AddCount(Amount):
	owner.CountUp(Amount)

