## mirrors the relative position of headset/controllers to self.
## either to use as a literal waldo or for ie. compensating for high speed.
## assumes xrcontroller3d and xrcamera3d are direct children of xrorigin


class_name XRCoordinateWaldo
extends Node3D

# TODO get this from global?
@export var xr_origin : TestPlayer

@onready var left_controller_position = $LeftControllerPosition
@onready var right_controller_position = $RightControllerPosition
@onready var camera_position = $CameraPosition


func _physics_process(delta):
	
	var left_hand = xr_origin.lhand
	var right_hand = xr_origin.rhand
	var headset = xr_origin.headset
	
	left_controller_position.position = left_hand.position
	right_controller_position.position = right_hand.position
	camera_position.position = headset.position
	
	#print("waldo position... ", right_controller_position.global_position)
