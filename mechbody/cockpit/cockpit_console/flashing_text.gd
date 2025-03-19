extends Node3D

@export var enabled = true :
	set(value): _set_value(value)

@export var blinker : Blinker

func _set_value(value):
	if value: 
		visible =  true
		blinker.start_blink()
	else: 
		visible = false
		blinker.stop_blink()
