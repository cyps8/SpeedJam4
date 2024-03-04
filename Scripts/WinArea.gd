extends Area2D

var active = false

var activated = false

func PlayerEntered(_body):
	if active && !activated && %Game.gameActive:
		activated = true
		%Game.Win()

func Activate():
	active = true