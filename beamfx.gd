
class_name Sword
extends MechTool


@export var recoil = 10
@export var particles :Array[GPUParticles3D]
@export var controller_action = "trigger_click"
@export var cool_slicer_vel = 30.0

@export var soul_counter : SoulCounter

@export var tip : Marker3D
@export var slicer : SlicerArea
@export var cool_slicer : CoolSlicer
@onready var damage_area = $DamageArea
@onready var slice_visual_mesh: MeshInstance3D = $SlicerArea/SliceVisualMesh

var powered = false
var last_position := Vector3.ZERO
var velocity := Vector3.ZERO # hand velocity relative to body
var velocity_integrator = 0



# CALLBACKS --------------------------------------------------------------------



func _ready():
	print("beam powering off")
	_power_off()


func _physics_process(delta: float) -> void:
	
	if !powered : return
	
	# get sword velocity relative to body
	
	var body_pos = hand.mechbody.global_position
	var new_pos = global_position - body_pos
	
	if last_position == Vector3.ZERO: velocity = Vector3.ZERO
	else: velocity = new_pos - last_position
	last_position = new_pos
	
	if !cool_slicer.slicing: 
		
		var len = velocity.length() / delta
		#print("SWORD VELOCITY ", len)
		if len > cool_slicer_vel: 
			velocity_integrator += 1
		else: 
			velocity_integrator = 0
		
		# enable slicer slightly earlier
		
		#if velocity_integrator > 15:
			#slicer.enabled = true
		#else:
			#slicer.enabled = false
		
		if velocity_integrator > 20: 
			
			if soul_counter.kills >= 2: 
				soul_counter.use_souls(2)
				cool_slicer.cool_slice()
				velocity_integrator = 0

	

func on_controller_input_pressed(action):
	super(action)
	if action == controller_action: _power_on()


func on_controller_input_released(action):
	super(action)
	if action == controller_action: _power_off()


func _on_area_3d_area_entered(area):
	if area.is_in_group("laser"):
		if tool_active and powered:
			if grabbable_controller.controller != null:
				grabbable_controller.controller.trigger_haptic_pulse("haptic", 5, 0.4, 0.2, 0)
			#_recoil()
	else:
		if tool_active: 
			#grabbable_controller.controller.trigger_haptic_pulse("haptic", 5, 0.4, 0.2, 0)
			pass


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


func _recoil():
	var bit : HandBit = hand.get_hand_bit()
	var impulse = bit.hand.linear_velocity * -1 * recoil
	bit.hand.apply_impulse(impulse, $RecoilPoint.global_position) # TODO
