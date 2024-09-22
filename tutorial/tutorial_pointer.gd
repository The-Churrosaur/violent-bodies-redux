
class_name TutorialPointer
extends Node3D


@export var lerp_weight = 2.0
var target : Node3D = self


func _physics_process(delta):
	global_position = global_position.lerp(target.global_position, lerp_weight * delta)
	
	rotate_y(0.1)


func set_target(new_target):
	target = new_target
