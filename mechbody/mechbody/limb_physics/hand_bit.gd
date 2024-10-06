
## physics master for mech hands

class_name HandBit
extends Node3D

@export var mechbody : MechBody
@export var hand : RigidBody3D
@export var anchor : RigidBody3D
@export var other_hand : HandBit

@export_category("Hand")
@export var hands : UtilityGlobals.hands

@export_category("Two Handed Joints")
@export var current_joint : MechTwoHandedJoint
@export var joints : Array[MechTwoHandedJoint]


@onready var limb_rotator : LimbRotator = $Hand/LimbRotator


var target = null
var joints_dict = {}


#TODO clean up these references

func _ready():
	for joint in joints:
		joints_dict[joint.id] = joint

func _physics_process(delta):
	
	if hands == UtilityGlobals.hands.RIGHT: 
		target = mechbody.right_arm_targeter
	else: 
		target = mechbody.left_arm_targeter 
	
	anchor.global_transform = target.arm_target.global_transform
	hand.global_rotation = target.arm_target.global_rotation
	
	target.arm.target_node = hand
	
	# equal and opposite
	if limb_rotator.recoil_body == null:
		limb_rotator.recoil_body = mechbody


func get_joint_by_id(id : String):
	if joints_dict.has(id): return joints_dict[id]
	else: print("JOINT NOT FOUND IN JOINT DICT: ", id)

func toggle_joint():
	
	#if !current_joint.enabled:
		#current_joint.node_a = current_joint.get_path_to(other_hand.hand)
		#current_joint.node_b = current_joint.get_path_to(hand)
	
	current_joint.enabled = !current_joint.enabled
