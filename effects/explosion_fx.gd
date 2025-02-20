
class_name ExplosionFX
extends Node3D

signal explosion_ended()
@export var boom_delay = 5.0

@export var bubbling : GPUParticles3D
@export var nova : GPUParticles3D
@export var gibs : GPUParticles3D
@export var smoketrail : GPUParticles3D

@export var audio : AudioStreamPlayer3D


func start_explosion_sequence():
	bubbling.emitting = true
	nova.emitting = true
	gibs.emitting = true
	smoketrail.emitting = true
	audio.play()


func _on_nova_finished():
	emit_signal("explosion_ended")
