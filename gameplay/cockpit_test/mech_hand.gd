
## mech hands 
## isolated from physics hands (hand bits)
## in charge of hand transform
## point of contact for mech grabbables (tools)

class_name MechHand
extends Node3D

@export var mechbody : MechBody
@export var current_tool : MechTool
@export var arm : ArmBase
@export var other_hand : MechHand
@export var two_handed = false
@export var hands : UtilityGlobals.hands

var grabbable : MechGrabbable = null
var hovering_grabbable : MechGrabbable = null


#region ===== CALLBACKS =====


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	# keeps self parented to hand
	# just testing
	global_transform = arm.hand_reference.global_transform
	#trigger_tool()
	#scale = Vector3.ONE
	
	# testing two handed
	if two_handed:
		if other_hand != null: look_at(other_hand.global_position)
	
	if grabbable is MechGrabbable: 
		if grabbable.kinematic_hold:
			
			var grab_point = grabbable.kinematic_grab_point
			var grab_point_transform = grab_point.transform.orthonormalized().inverse()
			
			## parent
			if grab_point.global_position == global_position:
				grabbable.global_transform = global_transform * grab_point_transform
			
			## else lerp
			else:
				grabbable.global_transform = grabbable.global_transform.interpolate_with( \
				global_transform * grab_point_transform, grabbable.kinematic_lerp)

func _on_grab_detection_area_area_entered(area):
	
	if area is MechGrabPoint:
		print("MECHGRABBABLE DETECED")
		hovering_grabbable = area.grabbable
		grab_hovered_grabbable()


func _on_grab_detection_area_area_exited(area):
	
	if area is MechGrabPoint:
		if area.grabbable == hovering_grabbable: 
			hovering_grabbable = null


func _on_grab_detection_area_body_entered(body):
	pass # Replace with function body.


func _on_grab_detection_area_body_exited(body):
	pass # Replace with function body.


#endregion


#region ===== PUBLIC =====


func trigger_tool():
	if current_tool != null:
		current_tool.trigger()


func get_hand_bit():
	if hands == UtilityGlobals.hands.LEFT: 
		return mechbody.left_hand_bit
	if hands == UtilityGlobals.hands.RIGHT:
		return mechbody.right_hand_bit


func grab_hovered_grabbable():
	if !hovering_grabbable is MechGrabbable: return
	
	grabbable = hovering_grabbable
	mechbody.current_two_hand_joint = get_hand_bit().get_joint_by_id(grabbable.two_handed_joint_id)



#endregion

