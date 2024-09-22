
## if masked is true ('head pointer' tagged collider is colliding with mask),
## will set headlook controller disabled 

class_name HeadlookMask
extends Node3D


@export var enabled = true
@export var headlook_controller : HeadlookController
@export var mask_areas : Array[Area3D]

var masked = false



func _ready():
	for area in mask_areas:
		area.area_entered.connect(on_mask_collider_area_entered)
		area.area_exited.connect(on_mask_collider_area_exited)


func _physics_process(delta):
	if masked and enabled: headlook_controller.temp_disabled = true


func on_mask_collider_area_entered(area):
	if area is HeadPointer: 
		masked == true
		headlook_controller.temp_disabled = true


func on_mask_collider_area_exited(area):
	if area is HeadPointer: 
		masked == false
		headlook_controller.temp_disabled = false

