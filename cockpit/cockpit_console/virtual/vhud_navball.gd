
class_name VHUDNavball
extends Node3D


@export var body : RigidBody3D

@onready var rotator = $Rotator
@onready var velocity_label = $VelocityLabel


func _physics_process(delta):
	var vel = body.linear_velocity
	var length = vel.length()
	if length < 0.1: 
		velocity_label.text = "0 m/s"
	else:
		rotator.look_at(global_position + vel)
		velocity_label.text = str(int(vel.length())) + " m/s"
