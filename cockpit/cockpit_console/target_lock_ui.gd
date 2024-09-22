
class_name TargetLockUI
extends Node3D

## paints this object
var target : Node3D 


func _physics_process(delta):
	
	## face target
	if target == null: return
	
	look_at(target.global_position)


func set_target(new_target):
	print("lock ui target set")
	target = new_target
	visible = true

func lost_target():
	#target = null
	#visible = false
	pass
