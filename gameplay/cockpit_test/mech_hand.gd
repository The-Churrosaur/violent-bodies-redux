
## mech hands 
## isolated from physics hands (hand bits)
## in charge of hand transform
## point of contact for mech grabbables (tools)
## TODO split grabbing into a separate class?

class_name MechHand
extends Node3D

@export var mechbody : MechBody
@export var current_tool : MechTool
@export var arm : ArmBase
@export var other_hand : MechHand
@export var two_handed = false
@export var hands : UtilityGlobals.hands

@export_category("Grabbing")
@export var lerp_parent_threshold_sq = 0.5

var grabbable : MechGrabbable = null
var hovering_grabbable : MechGrabbable = null

# grabbable state flags
enum STATE {RIGID, LERPING, FOLLOWING, NONE}
var grabbable_state : STATE = STATE.NONE


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
	
	# grabbing behavior
	if grabbable is MechGrabbable: 
		
		match grabbable_state:
			
			STATE.LERPING:
				_lerp_grabbable(delta)
			
			STATE.FOLLOWING:
				_parent_grabbable(delta)
			
			STATE.RIGID:
				pass
			
			STATE.NONE:
				pass


func _on_grab_detection_area_area_entered(area):
	
	if area is MechGrabPoint:
		var new_grabbable = area.grabbable
		if new_grabbable == grabbable: return
		if new_grabbable.grabbed: return
		
		hovering_grabbable = new_grabbable


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
	grabbable.grabbed = true
	
	if grabbable.kinematic_hold: 
		grabbable.freeze = true
	
	if grabbable.two_handed:
		var joint = get_hand_bit().get_joint_by_id(grabbable.two_handed_joint_id)
		mechbody.current_two_hand_joint = joint
	
	if grabbable.kinematic_hold: grabbable_state = STATE.LERPING
	else: grabbable_state = STATE.RIGID


func drop_grabbable():
	if !grabbable is MechGrabbable: return
	
	grabbable.grabbed = false
	grabbable.freeze = false
	hovering_grabbable = grabbable
	grabbable = null
	
	grabbable_state = STATE.NONE


#endregion

#region ===== PRIVATE =====

func _lerp_grabbable(delta):
	print("lerping...")
	var grab_point = grabbable.kinematic_grab_point
	var grab_point_transform = grab_point.transform.orthonormalized().inverse()
	grabbable.global_transform = grabbable.global_transform.interpolate_with( \
	global_transform * grab_point_transform, grabbable.kinematic_lerp)
	
	if grab_point.global_position.distance_squared_to(global_position) < lerp_parent_threshold_sq:
		grabbable_state = STATE.FOLLOWING
	
	#if grab_point.global_transform.is_equal_approx(global_transform):
		#grabbable_state = STATE.FOLLOWING


func _parent_grabbable(delta):
	var grab_point = grabbable.kinematic_grab_point
	var grab_point_transform = grab_point.transform.orthonormalized().inverse()
	grabbable.global_transform = global_transform * grab_point_transform
	print("parenting")

#endregion
