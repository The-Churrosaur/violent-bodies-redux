
## recenters the playspace so that the player's head transform is aligned with 
## the transform of head_reference

class_name PlayspaceRecenterer
extends XRInputProcessor

@export var default_head_reference : Node3D
@export var global_recenter_action = "by_button"



func _on_input_down(action, controller):
	super(action, controller)
	if action == global_recenter_action: recenter()


func recenter(reference = default_head_reference):
	
	if !XRPlayerGlobals.is_nodes_set: return
	
	var headset = XRPlayerGlobals.headset
	var origin = XRPlayerGlobals.origin
	
	# sync transform
	
	# want transformation headset -> reference
	# apply htr transformation to origin
	
	# htr = headset -> origin -> reference
	#var htr : Transform3D =  headset.global_transform.affine_inverse() * default_head_reference.global_transform
	#origin.global_transform = origin.global_transform * htr
	
	if origin is TestPlayer: 
		origin.dolly.global_transform = reference.global_transform
	
	var headset_local_transform = headset.transform
	origin.transform = headset_local_transform.affine_inverse()
	
	## TODO does elevating the origin cause any problems?
	
	origin.rotation.x = 0
	origin.rotation.z = 0
	
	
