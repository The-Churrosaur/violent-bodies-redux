extends MechGrabbable
@onready var jolt_generic_6dof_joint_3d = $JoltGeneric6DOFJoint3D

func finish_grabbing():
	super()
	#jolt_generic_6dof_joint_3d.enabled = false
	#var new_joint = jolt_generic_6dof_joint_3d.duplicate()
	#add_child(new_joint)
	#new_joint.enabled = true
