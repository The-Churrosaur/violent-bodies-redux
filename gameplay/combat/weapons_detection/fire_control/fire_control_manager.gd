
## intermediary between controller, sensors, and multiple ws:
## sends tracks to ws.
## gives encapsulated engagement orders to ws.
## updates ws on a timer loop

## TODO multiple target distribution 
## - query turrets for los 


class_name FireControlManager
extends Node


enum ENGAGEMENT_STATE {FREE, COMMAND, HOLD}


@export_subgroup("Components")
@export var sensors : Array[Sensor]
@export var weapons_systems : Array[WeaponSystem]

@onready var ooda_timer: Timer = $oodaTimer

var engagement_state := ENGAGEMENT_STATE.HOLD
var tracks : Array[TargetTrack] = []


func _on_ooda_timer_timeout() -> void:
	update_fcm()


# -- state setters


func set_engagement_free():
	engagement_state = ENGAGEMENT_STATE.FREE


func set_engagement_command():
	engagement_state = ENGAGEMENT_STATE.COMMAND


func set_engagement_hold():
	engagement_state = ENGAGEMENT_STATE.HOLD


# -- fire control


func update_fcm():
	get_targets()
	update_ws()


func get_targets():
	tracks = []
	for sensor in sensors: 
		tracks.append_array(sensor.get_tracks())


func update_ws():
	
	# TODO
	if tracks.is_empty(): return
	var target = tracks[0]
	
	match engagement_state:
		
		ENGAGEMENT_STATE.FREE:
			for weapon in weapons_systems:
				weapon.engage_target(target)
		
		ENGAGEMENT_STATE.COMMAND:
			pass
		
		ENGAGEMENT_STATE.HOLD:
			for weapon in weapons_systems:
				weapon.disengage()
