extends Node3D

## TODO PERFORMANCE

@export var reservoir : VariantReservoir

func play_fx():
	var flash = reservoir.pop()
	add_child(flash)
	flash.position = Vector3.ZERO
	flash.play_fx()
