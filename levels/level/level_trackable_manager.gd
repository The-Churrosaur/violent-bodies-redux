
class_name LevelTrackableManager
extends Node

signal trackable_registered(trackable)
signal trackable_deregistered(trackable)

@export var trackables = {}

@export_subgroup("components")
@export var level : Level


func _ready() -> void:
	register_child_trackables()


# -- trackable management


## trackables register themselves by default, (except at startup)
func register_trackable(trackable : TrackableArea):
	trackables[trackable] = true
	print("trackable registered: ", trackable)


func deregister_trackable(trackable : TrackableArea):
	trackables[trackable] = false
	print("trackable DEREGISTERED: ", trackable)


## recursively searches children - not fast
func register_child_trackables(node = level):
	
	for child in node.get_children():
		if child is TrackableArea: register_trackable(child)
		if child.get_child_count() > 0: register_child_trackables(child)


# -- trackable info


func get_faction_trackables(faction : LevelGlobals.FACTIONS):
	var arr = []
	for trackable in trackables.keys(): 
		if trackable.faction == faction: arr.append(trackable)
	return arr
