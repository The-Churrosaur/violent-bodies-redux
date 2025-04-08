
class_name SoulCounter
extends Node3D


var kills = 0

@onready var soul_particles: GPUParticles3D = $SoulParticles


func _on_kill_counter_enemy_killed(body: Variant) -> void:
	kills += 1
	soul_particles.amount = kills
	soul_particles.set("parameters/turbulence_noise_strength", 100) # TODO this doesn't work
	
	print("SOULCOUNTER kills: ", kills)


func use_souls(amount_used):
	kills -= amount_used
	if kills < 0 : kills = 0
	soul_particles.amount = kills
