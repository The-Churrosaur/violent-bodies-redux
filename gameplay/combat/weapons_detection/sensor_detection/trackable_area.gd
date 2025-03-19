
## to be detected by sensors/target detectors.
## intermediary between detectors and body.
## contracts visibility, death signal etc.


class_name TrackableArea
extends Area3D



signal death(targetable : TrackableArea)
signal detected()

@export var body : PhysicsBody3D
@export var faction : LevelGlobals.FACTIONS = LevelGlobals.FACTIONS.PLAYER_ALLIED
var is_detected = false



## you've detected me
func detect():
	is_detected = true


## you've lost me
func lose_detection():
	is_detected = false


## signaled from NPC controller or player
func _on_death():
	death.emit(self)
