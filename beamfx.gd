
class_name Sword
extends MechTool


@export var particles :Array[GPUParticles3D]
@export var controller_action = "trigger_click"

@onready var damage_area = $DamageArea

var powered = false



# CALLBACKS --------------------------------------------------------------------



func _ready():
	_power_off()


func _physics_process(delta):
	pass


func on_controller_input_pressed(action):
	super(action)
	if action == controller_action: _power_on()


func on_controller_input_released(action):
	super(action)
	if action == controller_action: _power_off()



func _on_area_3d_area_entered(area):
	if area.is_in_group("laser"):
		if tool_active:
			grabbable_controller.controller.trigger_haptic_pulse("haptic", 5, 0.4, 0.2, 0)
	else:
		if tool_active: 
			grabbable_controller.controller.trigger_haptic_pulse("haptic", 5, 0.4, 0.2, 0)



# PUBLIC -----------------------------------------------------------------------



func toggle():
	if powered: _power_off()
	else: _power_on()



# PRIVATE ----------------------------------------------------------------------


func _power_on():
	for particle in particles : particle.emitting = true
	powered = true
	damage_area.monitorable = true
	grabbable_controller.controller.trigger_haptic_pulse("haptic", 5, 0.2, 0.4, 0)
	


func _power_off():
	for particle in particles : particle.emitting = false
	powered = false
	damage_area.monitorable = false


