
## mech hands 
## isolated from physics hands (hand bits)
## in charge of hand transform
## point of contact for mech grabbables (tools)
## TODO split grabbing into a separate class?
# TODO only allow grabbing at certain angles

class_name MechHand
extends Node3D

@export var mechbody : MechBody
@export var tool_manager : MechHandToolManager
@export var current_tool : MechTool
@export var arm : ArmBase
@export var arm_targeter : ArmTargeter
@export var other_hand : MechHand
@export var two_handed = false
@export var hands : UtilityGlobals.hands

@export_subgroup("Grabbing")
@export var lerp_parent_threshold_sq = 0.5
@export var lerp_parent_threshold_angle = PI/8
@export var parent_to_handbit = true

var grabbing_primary = false
var grabbing_secondary = false
var grabbable : MechGrabbable = null
var hovering_grabbable : MechGrabbable = null
var hovering_area : MechGrabPoint = null
@onready var hand_reference_tracker = $HandReferenceTracker

# grabbable state flags
enum STATE {RIGID, LERPING, FOLLOWING, NONE}
var grabbable_state : STATE = STATE.NONE

# grabbable -> hand bit
#var transferred_colliders : Array[CollisionShape3D]



#region ===== CALLBACKS =====


# Called when the node enters the scene tree for the first time.
func _ready():
	
	await get_tree().create_timer(1.0).timeout
	trigger_tool()
	
	pass # Replace with function body.


func _physics_process(delta):
	# keeps self parented to hand
	# just testing
	#hand_reference_tracker.global_transform = arm.hand_reference.global_transform
	#global_transform = hand_reference_tracker.global_transform
	global_transform = get_hand_bit().hand.global_transform
	#trigger_tool()
	#scale = Vector3.ONE
	
	# grabbing behavior
	if grabbable is MechGrabbable: 
		
		match grabbable_state:
			
			STATE.LERPING:
				_lerp_grabbable(delta)
			
			STATE.FOLLOWING:
				
				if grabbing_primary and grabbable.grabbed_secondary:
					if other_hand != null: 
						#
						look_at(other_hand.global_position)
						#rotation.z = arm.hand_reference.rotation.z
						#arm_targeter.alt_lookat_target = other_hand
						pass
				
				else:
					#arm_targeter.alt_lookat_target = null
					pass
				
				
				_parent_grabbable()
			
			STATE.RIGID:
				pass
			
			STATE.NONE:
				pass
		
		# two handed grabbing
		#if grabbing_primary and mechbody.is_two_hand_grabbing:
			#mechbody.current_two_hand_joint.global_transform = global_transform


func _on_grab_detection_area_area_entered(area):
	
	if area is MechGrabPoint:
		var new_grabbable = area.grabbable
		if new_grabbable == grabbable: return
		
		print("grab area entered: ", area)
		print("hovering grabbable set: ", new_grabbable)
		hovering_grabbable = new_grabbable
		hovering_area = area


func _on_grab_detection_area_area_exited(area):
	
	if area is MechGrabPoint:
		if area.grabbable == hovering_grabbable: 
			print("Grab area left: ", area)
			print("resetting hovering_grabbable to null")
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
	print("hand attempting to grab... ", hovering_grabbable)
	if !hovering_grabbable is MechGrabbable: 
		print("hovering grabbable is not mechgrabbable: ", hovering_grabbable)
		return
	
	# if area is primary
	if !hovering_area.secondary:
		print("grabbing, hover area is primary")
		# if not grabbed
		if !hovering_grabbable.grabbed:
			print("grabbing as primary")
			_grab_hovered_as_primary()
		# if primary and grabbed
		else:
			print("Attempting to grab claimed primary")
			pass
	
	# if area is secondary
	else:
		# secondary and not grabbed
		print("grabbing, hover area is secondary")
		if !hovering_grabbable.grabbed:
			_grab_hovered_as_physics()
		# secondary and grabbed
		else:
			print("grabbing as secondary")
			_grab_hovered_as_secondary()


func drop_grabbable():
	if !grabbable is MechGrabbable: return
	
	if grabbing_primary: _drop_as_primary()
	if grabbing_secondary: _drop_as_secondary()
	
	grabbable_state = STATE.NONE


#endregion

#region ===== PRIVATE =====


func _grab_hovered_as_primary():
	grabbing_primary = true
	grabbable = hovering_grabbable
	grabbable.grabbed = true
	grabbable.primary_grabber = self
	
	if grabbable.kinematic_hold: 
		grabbable.freeze = true
	
	if grabbable.two_handed:
		var joint = get_hand_bit().get_joint_by_id(grabbable.two_handed_joint_id)
		mechbody.current_two_hand_joint = joint
		print("setting 2hand joint: ", joint)
	
	if grabbable.kinematic_hold: grabbable_state = STATE.LERPING
	else: grabbable_state = STATE.RIGID
	
	if grabbable.is_tool: tool_manager.set_tool_override(grabbable.tool)


func _grab_hovered_as_secondary():
	
	# tell body
	mechbody.enable_current_twohand_joint(self)
	
	# tell other hand
	other_hand._otherhand_grabbed_secondary()
	
	
	grabbing_secondary = true
	grabbable = hovering_grabbable
	grabbable.grabbed_secondary = true
	grabbable.secondary_grabber = self
	
	# prevents unwanted rotation as the hand bit pushes back against gun rotation
	#get_hand_bit().limb_rotator.rotate = false


func _grab_hovered_as_physics():
	pass


func _drop_as_primary():
	
	_return_colliders(grabbable)
	
	if grabbable.grabbed_secondary: grabbable.secondary_grabber.drop_grabbable()
	if grabbable.is_tool and grabbable.tool == tool_manager.current_tool: 
		tool_manager.set_tool(tool_manager.current_index)
	
	grabbing_primary = false
	grabbable.grabbed = false
	grabbable.primary_grabber = null
	grabbable.freeze = false
	
	hovering_grabbable = grabbable
	grabbable = null


func _drop_as_secondary():
	
	print("DROPPING AS SECONDARY")
	print(hovering_area, hovering_grabbable)
	
	# tell body
	mechbody.disable_current_twohand_joint()
	
	# tell other hand
	other_hand._otherhand_dropped_secondary()
	
	grabbing_secondary = false
	grabbable.grabbed_secondary = false
	grabbable.secondary_grabber = null
	
	hovering_grabbable = grabbable
	grabbable = null
	
	#get_hand_bit().limb_rotator.rotate = true


# called by other hand on successful grab as secondary
func _otherhand_grabbed_secondary():
	get_hand_bit().stabilized_hand = true


func _otherhand_dropped_secondary():
	get_hand_bit().stabilized_hand = false



# -- PHYSICS HELPERS



func _transfer_colliders(grabbable : MechGrabbable):
	var hand_bit = get_hand_bit()
	for collider in grabbable.transfer_colliders:
		collider.reparent(hand_bit.hand)
		print("collider transferred: ", collider)


func _return_colliders(grabbable : MechGrabbable):
	for collider in grabbable.transfer_colliders:
		collider.reparent(grabbable)


# when grabbing is finalized (done lerping) 
func _set_parented_locked():
	grabbable_state = STATE.FOLLOWING
	grabbable.freeze = true
	grabbable.finish_grabbing()
	_parent_grabbable()
	_transfer_colliders(grabbable)


func _lerp_grabbable(delta):

	var grab_point = grabbable.kinematic_grab_point
	var grab_point_transform = grab_point.transform.orthonormalized().inverse()
	grabbable.global_transform = grabbable.global_transform.interpolate_with( \
	global_transform * grab_point_transform, grabbable.kinematic_lerp)
	
	# threshold
	
	var distance_sq = grab_point.global_position.distance_squared_to(global_position)
	var grab_point_quat = grab_point.global_basis.get_rotation_quaternion()
	var self_quat = global_basis.get_rotation_quaternion()
	var quat_dif = grab_point_quat.angle_to(self_quat)
	
	if distance_sq < lerp_parent_threshold_sq and quat_dif < lerp_parent_threshold_angle:
		_set_parented_locked()
	
	#if grab_point.global_transform.is_equal_approx(global_transform):
		#grabbable_state = STATE.FOLLOWING


func _parent_grabbable():
	var grab_point = grabbable.kinematic_grab_point
	var grab_point_transform = grab_point.transform.orthonormalized().inverse()
	
	if parent_to_handbit:
		grabbable.global_transform = get_hand_bit().hand.global_transform * grab_point_transform
	else:
		grabbable.global_transform = global_transform * grab_point_transform


#endregion
