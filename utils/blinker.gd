
@tool

class_name Blinker
extends Node


signal blink_on()
signal blink_off()

@export var active = false
@export var autostart = true
@export var target : Node3D
@export var on_time = 1.0
@export var off_time = 1.0


@onready var on_timer = $OnTimer
@onready var off_timer = $OffTimer


## turns light off for duration off_timer
func _on_on_timer_timeout(loop = true):
	
	## check to break loop here (remains visible
	if !active: return
	
	off_timer.start(off_time)
	target.visible = false
	blink_off.emit()


## turns light on for duration on_timer
func _on_off_timer_timeout():
	on_timer.start(on_time)
	target.visible = true
	blink_on.emit()


func start_blink():
	off_timer.start()


func stop_blink():
	off_timer.stop()
	on_timer.stop()
