
## mimics physics behavior of jointbutton while being fully kinematic
## moves button along y axis.
## assumes self as reference for button 'zero', and area/anim as children

## TODO breaks at high speed due to collision position imprecision
## either use rigidbody with continuous collision
## or locally store 'cockpit position' (as opposed to subtracting global pos) 

class_name FakeJointButton
extends Node3D

signal button_pressed()
signal button_released()

@export var button_area : Area3D
@export var button_anim : Node3D
@export var button_grabbable : MyXRGrabbable
@export var lerp_weight = 0.5

@export_subgroup("limits")
@export var max_y = 0.0
@export var min_y = -0.1
@export var press_distance = -0.08

var pushing_body
var body_displacement : Vector3
var is_button_pressed = false


func _ready():
	button_area.body_entered.connect(_on_area_body_entered)
	button_area.body_exited.connect(_on_area_body_exited)
	button_area.area_entered.connect(_on_area_body_entered)
	button_area.area_exited.connect(_on_area_body_exited)


func _physics_process(delta):
	
	var target_y = 0.0
	
	# maintain original displacement while being pushed
	if pushing_body != null:
		target_y = button_anim.to_local(pushing_body.global_position - body_displacement).y
		#testsets
		#target_y = pushing_body.
	
	target_y = clamp(target_y, min_y, max_y)
	button_anim.position.y = lerp(button_area.position.y, target_y, lerp_weight)
	
	# press logic
	if !is_button_pressed:
		if button_anim.position.y <= press_distance:
			is_button_pressed = true
			button_pressed.emit()
	else:
		if button_anim.position.y > press_distance:
			is_button_pressed = false
			button_released.emit()



func _on_area_body_entered(body):
	#print("BUTTON ENTERED")
	pushing_body = body
	body_displacement = body.global_position - button_anim.global_position
	#print(body_displacement)


func _on_area_body_exited(body):
	pushing_body = null


func _on_my_xr_grabbable_hovered(grabber):
	var controller = grabber.controller 
	if controller != null: controller.trigger_haptic_pulse("haptic", 5, 0.1, 0.1, 0)
