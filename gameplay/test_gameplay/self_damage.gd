
class_name SelfDamage
extends Node3D


@export var health : HealthModule
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var gpu_particles_3d_2: GPUParticles3D = $GPUParticles3D2
@onready var hit_fx: GPUParticles3D = $hitFX


func _ready() -> void:
	
	health.health_changed.connect(_on_health_changed)
	health.health_zero.connect(_on_health_zero)


func _on_health_changed(amount):
	gpu_particles_3d.restart()
	hit_fx.restart()
	for controller in XRPlayerGlobals.controllers.values():
		controller.trigger_haptic_pulse("haptic", 5, 0.4, 0.2, 0)


func _on_health_zero():
	
	#gpu_particles_3d_2.emitting = true
	
	pass
