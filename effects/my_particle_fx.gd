

## fires and tracks collections of oneshot particles
class_name MyParticleFX
extends MyFX



@export var particles : Array[GPUParticles3D]


## tracks which particles are playing
var particles_playing = {} # particle -> playing


func _ready() -> void:
	for particle in particles: 
		particles_playing[particle] = false
		particle.finished.connect(_on_particle_finished.bind(particle))


func _on_particle_finished(particle):
	particles_playing[particle] = false
	if !particles_playing.values().has(true): _finished()


func play_fx():
	super()
	for particle in particles_playing: 
		particle.restart()
		particles_playing[particle] = true


func stop_fx():
	super()
	for particle in particles:
		particle.emitting = false
