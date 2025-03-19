
## mirrors the transform of the headset in whatever local reference frame you need it
class_name HeadsetLocalTransform
extends Node3D

func _physics_process(delta):
	# get headset transform
	if XRPlayerGlobals.is_nodes_set:
		global_transform = XRPlayerGlobals.headset.global_transform
