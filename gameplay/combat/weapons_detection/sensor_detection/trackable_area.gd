
## to be detected by sensors/target detectors.

## intermediary between detectors and body.
## contracts visibility, death signal etc.


class_name TrackableArea
extends Area3D



signal death(targetable : TrackableArea)
signal detected()

@export var body : PhysicsBody3D
@export var faction := LevelGlobals.FACTIONS.PLAYER_ALLIED # iff

var is_detected = false



func _ready() -> void:
	
	# register self
	
	var level = LevelGlobals.level
	if level: level.trackable_manager.register_trackable(self)
	
	# register death signal
	
	if body is NPCBody: body.death.connect(_on_death)
	if body is MechBody: pass # TODO


## call if you've detected me
func detect():
	is_detected = true


## call if you've lost me
func lose_detection():
	is_detected = false


## signaled from NPC controller or player
func _on_death():
	
	death.emit(self)
	
	var level = LevelGlobals.level
	if level: level.trackable_manager.deregister_trackable(self)
