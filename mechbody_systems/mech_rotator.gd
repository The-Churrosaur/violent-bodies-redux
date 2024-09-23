
## encapsulates LimbRotator to orient the mech using forces
## call track_target / track_match_target / stop_tracking to use

class_name MechRotator
extends Node3D


## tracking target (lookat) - will attempt to look at this node
var target : Node3D

## alternate reference - will attempt to match this node's rotation
var match_target : Node3D
var use_match_target = false


@export_group("internal references")
@export var limb_rotator : LimbRotator

## limb rotator targets this
@export var rotation_target : Node3D



func _physics_process(delta):
	
	if use_match_target:
		if match_target == null: return
		rotation_target.global_rotation = match_target.global_rotation
	
	else:
		if target == null: return
		rotation_target.look_at(target.global_position)


func track_target(new_target, rotate_by_axis = false):
	target = new_target
	limb_rotator.active = true
	limb_rotator.rotate_by_axis = rotate_by_axis


func track_match_target(new_match_target, rotate_by_axis = false):
	match_target = new_match_target
	limb_rotator.active = true
	limb_rotator.rotate_by_axis = rotate_by_axis
	use_match_target = true


func stop_tracking():
	target = null
	match_target = null
	limb_rotator.active = false
	use_match_target = false
