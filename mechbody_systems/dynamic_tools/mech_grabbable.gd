class_name MechGrabbable
extends RigidBody3D

## when grabbed, will be deactivated and parented at grab point
@export var kinematic_hold = true

## mech hand will grab here
## TODO currently assumes this is a direct child for transform purposes - 
@export var kinematic_grab_point : Marker3D

## how fast this grabbable will lerp to hand
@export var kinematic_lerp = 0.01

## is two handed
@export var two_handed = false

## what type of hand joint should be used to connect the second hand
@export var two_handed_joint_id = "default"


## to disallow multiple grabbing 
var grabbed = false
var grabbed_secondary = false