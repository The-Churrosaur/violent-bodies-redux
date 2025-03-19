
## looks ever downwards
## the perfect gyroscope

class_name GravityLooker
extends Node3D

func _physics_process(delta):
	global_transform.basis = Basis.IDENTITY
	#rotate_x(PI/2)
