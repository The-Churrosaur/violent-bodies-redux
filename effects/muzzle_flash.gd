extends Node3D

@export var flash_instance : PackedScene

func play_fx():
	var flash = flash_instance.instantiate()
	add_child(flash)
	flash.position = Vector3.ZERO
	flash.play_fx()
