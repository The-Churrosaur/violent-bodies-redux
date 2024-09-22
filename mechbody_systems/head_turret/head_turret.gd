

## tracks turretbase to a facing direction of a tracking base + convergence.
## assumes -Z of tracking base node is direction
## TODO physics?

class_name HeadTurret
extends Node3D


## will attempt to track
@export var active = true

## base node which rotates
@export var turret_base : Node3D

## convergence distance
@export var convergence = Vector3(0,0,500.0)

## lerp coefficient (seconds)
@export var lerp_weight = 3.0

## will track towards where this node is looking (-z)
@export var tracking_base : Node3D

## will attempt to match this node's transform (currently rotation lerp)
@onready var local_transform_target = $LocalTransformTarget

	

func _physics_process(delta):
	
	if !active: return
	if tracking_base == null: return
	
	# set target transform
	var target_endpoint = tracking_base.global_transform
	target_endpoint = target_endpoint.translated_local(convergence)	
	
	# local target looks at endpoint
	local_transform_target.look_at(target_endpoint.origin)
	
	# lerp turretbase to local target
	turret_base.transform = turret_base.transform.interpolate_with( \
											local_transform_target.transform, lerp_weight * delta)
