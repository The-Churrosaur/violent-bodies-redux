
class_name Missile
extends RigidBody3D

@export var thrust_force = 10000

@onready var mech_rotator: MechRotator = $MechRotator
@onready var hit_fx: GPUParticles3D = $hitFX

var target : TargetTrack = null
var thrusting = false


func fire_missile(target):
	self.target = target
	#mech_rotator.track_target(target.trackable_area)
	thrusting = true


func _physics_process(delta: float) -> void:
	if thrusting: 
		apply_central_force(-basis.z * thrust_force)
		
		$looker.look_at(target.trackable_area.global_position)
		var a = Quaternion(transform.basis)
		var b = Quaternion($looker.global_transform.basis)
		var c = a.slerp(b, 4.0 * delta)
		transform.basis = Basis(c)


func _on_damage_area_on_hit() -> void:
	hit_fx.restart()
	thrusting = false


func _on_hit_fx_finished() -> void:
	queue_free()
