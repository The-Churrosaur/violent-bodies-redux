
## intermediary between sensor and multiple ws:
## sends tracks to ws.
## TODO multiple target distribution 
## - query turrets for los 


class_name FireControlManager
extends Node


@export_subgroup("Components")
@export var sensors : Array[Sensor]
@export var weapons_systems : Array[WeaponSystem]


func distribute_targets():
	
	## accumulate tracks from all sensors
	
	var tracks : Array[TargetTrack] = []
	for sensor in sensors: tracks.append_array(sensor.get_tracks())
		
	## assign accumulated tracks
	
	for weapon in weapons_systems:
		weapon.assign_target_list(tracks)
