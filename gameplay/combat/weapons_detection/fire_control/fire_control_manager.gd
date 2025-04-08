
## intermediary between controller, sensors, and multiple ws:
## sends tracks to ws.
## gives encapsulated engagement orders to ws

## TODO multiple target distribution 
## - query turrets for los 


class_name FireControlManager
extends Node


enum ENGAGEMENT_STATE {AT_WILL, COMMAND, HOLD}


@export_subgroup("Components")
@export var sensors : Array[Sensor]
@export var weapons_systems : Array[WeaponSystem]

@onready var ooda_timer: Timer = $oodaTimer

var engagement_state := ENGAGEMENT_STATE.HOLD


## TODO TODO

func _on_ooda_timer_timeout() -> void:
	distribute_targets()
	
	match engagement_state:
		
		ENGAGEMENT_STATE.AT_WILL:
			for weapon in weapons_systems:
				weapon.set_engaging()
		
		ENGAGEMENT_STATE.COMMAND:
			for weapon in weapons_systems:
				weapon.set_tracking()
		


func set_engagement_at_will():
	engagement_state = ENGAGEMENT_STATE.AT_WILL


func set_engagement_command():
	engagement_state = ENGAGEMENT_STATE.COMMAND


func set_engagement_hold():
	engagement_state = ENGAGEMENT_STATE.HOLD


func distribute_targets():
	
	## accumulate tracks from all sensors
	
	var tracks : Array[TargetTrack] = []
	for sensor in sensors: tracks.append_array(sensor.get_tracks())
		
	## assign accumulated tracks
	
	for weapon in weapons_systems:
		weapon.assign_target_list(tracks)
