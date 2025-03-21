
class_name Cockpit
extends Node3D

@export_subgroup("references")
@export var left_arm : ArmBase
@export var right_arm : ArmBase
@export_subgroup("player controller nodes")
@export var left_shoulder : Node3D
@export var right_shoulder : Node3D
@export var left_handle : RigidBody3D
@export var right_handle : RigidBody3D
