
## component of a weapons system.
## chooses a target based on target criteria selected

class_name WSTargetPrioritizer
extends Node


enum TARGET_CRITERIA {CLOSEST, FARTHEST} ## todo LOW_HEALTH, HIGH_HEALTH

@export var ws : WeaponSystem

var target_criteria : TARGET_CRITERIA = TARGET_CRITERIA.CLOSEST


## call me
func choose_target_track(tracks : Array[TargetTrack]):
	match target_criteria:
		TARGET_CRITERIA.CLOSEST: return _get_closest_target(tracks)
		TARGET_CRITERIA.FARTHEST: return _get_farthest_target(tracks)


## gets closest track
func _get_closest_target(tracks : Array[TargetTrack]):
	
	if tracks.is_empty(): return null
	
	var closest = tracks[0]
	var closest_distance = _target_distance(closest)
	
	for target in tracks:
		var new_distance = _target_distance(target)
		if new_distance < closest_distance: 
			closest = target
			closest_distance = new_distance
	
	return closest


## gets farthest track
func _get_farthest_target(tracks : Array[TargetTrack]):
	
	var farthest = tracks[0]
	var farthest_distance = _target_distance(farthest)
	
	for target in tracks:
		var new_distance = _target_distance(target)
		if new_distance > farthest_distance: 
			farthest = target
			farthest_distance = new_distance
	
	return farthest


func _target_distance(track: TargetTrack):
	return (track.trackable_area.body.global_position - ws.global_position).length_squared()
