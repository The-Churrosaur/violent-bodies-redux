extends Node3D

@export var target_node : Node3D
@export var skeleton_ik : SkeletonIK3D
@export var skeleton : Skeleton3D
@export var hand_reference : Node3D
@export var wrist_reference : Node3D


func _ready():
	
	skeleton_ik.target_node = skeleton_ik.get_path_to(target_node)
	skeleton_ik.start()


func _physics_process(delta):
	
	var hand_bone_id = skeleton.get_bone_count() - 1
	var hand_transform = skeleton.get_bone_global_pose(hand_bone_id)
	hand_reference.global_transform = skeleton.global_transform * hand_transform
	
	var elbow_transform = skeleton.get_bone_global_pose(hand_bone_id - 1)
	wrist_reference.global_transform = skeleton.global_transform * elbow_transform
	wrist_reference.global_position = hand_reference.global_position
	
