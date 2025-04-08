
class_name MyFX
extends Node3D


signal fx_finished()


## if independant, will reparent itself and handle cleanup
@export var independant = false

## will play these as well
@export var recursive_fx : Array[MyFX]



func play_fx():
	if independant: reparent(LevelGlobals.level)
	for fx in recursive_fx: fx.play_fx()


func stop_fx():
	for fx in recursive_fx: fx.stop_fx()
	_finished()


func _finished():
	fx_finished.emit()
	if independant: queue_free()
