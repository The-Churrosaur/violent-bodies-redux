
class_name NPCDeath
extends Node3D


signal done_dying()

@export var death_fx : MyFX


func die():
	print("death, dying")
	
	if death_fx: 
		death_fx.play_fx()
		await death_fx.fx_finished
	
	done_dying.emit()
