
## temp - does not incorporate lead or physics
extends WeaponAimer


@export var turret_base : Node3D
@export var lead_computer : LeadComputer
@export var lerp_coefficient = 4.0
@onready var rotation_target: Node3D = $rotation_target


func acquire_target(target):
	super(target)


func cease_fire():
	super()


func _physics_process(delta: float) -> void:
	if !target: return 
	
	var target_pos = lead_computer.predict(target.trackable_area.body)
	if !target_pos: target_pos = target.trackable_area.global_position
	rotation_target.look_at(target_pos)
	turret_base.global_transform = turret_base.global_transform.interpolate_with(
									rotation_target.global_transform, lerp_coefficient * delta)
	
	#if turret_base.global_transform.is_equal_approx(rotation_target.global_transform):
		#if !target_is_acquired:
			#target_is_acquired = true
			#target_acquired.emit()
	#
	#else:
		#if target_is_acquired:
			#target_is_acquired = false
			#target_lost.emit()
