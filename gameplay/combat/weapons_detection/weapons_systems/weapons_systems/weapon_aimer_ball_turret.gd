
## temp - does not incorporate physics
extends WeaponAimer


@export var turret_base : Node3D
@export var lead_computer : LeadComputer
@export var lerp_coefficient = 8.0
@onready var rotation_target: Node3D = $rotation_target


func aim_target(target):
	super(target)


func stop_aiming():
	super()


func _physics_process(delta: float) -> void:
	if !target: return 
	
	var target_pos = lead_computer.predict(target.trackable_area.body)
	
	#var target_pos = target.trackable_area.global_position
	if target_pos: rotation_target.look_at(target_pos)
	turret_base.global_transform = turret_base.global_transform.interpolate_with(
									rotation_target.global_transform, lerp_coefficient * delta)
	
	
	var angle = turret_base.global_basis.z.angle_to(rotation_target.global_basis.z)
	
	if angle < 0.1:
		if !target_is_acquired:
			target_is_acquired = true
			print("TARGET ACQUIRED", angle)
			target_acquired.emit()
	else:
		if target_is_acquired:
			target_is_acquired = false
			print("TARGET LOST", angle)
			target_lost.emit()
