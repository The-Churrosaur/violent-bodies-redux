
class_name Shield
extends MechTool

@export var controller_action = "trigger_click"


@onready var mesh_instance_3d = $MeshInstance3D
@onready var area_3d = $Area3D

var powered = false


func _process(delta):
	if powered and grabbable_controller is MyXRGrabbable:
		grabbable_controller.controller.trigger_haptic_pulse("haptic", 1, 0.2, 0.2, 0)


func on_controller_input_pressed(action):
	super(action)
	if action == controller_action: _shield_on()


func on_controller_input_released(action):
	super(action)
	if action == controller_action: _shield_off()


func _shield_on():
	mesh_instance_3d.visible = true
	area_3d.monitorable = true
	powered = true

func _shield_off():
	mesh_instance_3d.visible = false
	area_3d.monitorable = false
	powered = false

