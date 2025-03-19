
## holds target tracks 

class_name TargetManager
extends Node3D


signal new_target(targetable)
signal target_lost(targetable)


@export var target_detector : TargetDetector


var target_tracks = {} ## target_track -> true



func _ready() -> void:
	target_detector.target_entered.connect(_on_target_detector_target_entered)
	target_detector.target_exited.connect(_on_target_detector_target_exited)


func _on_target_detector_target_entered(targetable : TrackableArea) -> void:
	if _has_targetable(targetable): return
	var target_track = target_track_script.new()
	target_track.setup(targetable)
	new_target.emit(targetable)


func _on_target_detector_target_exited(targetable : TrackableArea) -> void:
	if !_has_targetable(targetable): return
	


func get_targets() -> Array:
	return target_tracks.keys()


func _has_targetable(targetable : TrackableArea) -> bool:
	for target in target_tracks: if target.targetable == targetable: return true
	return false
