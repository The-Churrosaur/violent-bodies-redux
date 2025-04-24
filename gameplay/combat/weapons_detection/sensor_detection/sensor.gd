
## sensor and track holder
## creates new tracks when object enters.
## evaluates track strength etc. on evaluate_tracks()

class_name Sensor
extends Node3D


@export_subgroup("Components")


@export_subgroup("Parameters")

@export var radius = 1000
@export var track_faction : LevelGlobals.FACTIONS


@onready var sensor_timer: Timer = $SensorTimer

var tracks = {} ## trackable_area -> track


#region callbacks


func _on_sensor_timer_timeout() -> void:
	update_tracks()


#endregion
#region public


func update_tracks():
	
	# default behavior - gets all enemies within radius
	
	var trackable_manager := LevelGlobals.level.trackable_manager
	var faction_trackables = trackable_manager.get_faction_trackables(track_faction)
	
	for trackable : TrackableArea in faction_trackables: 
		var distance = (trackable.body.global_position - global_position).length_squared()
		if distance < radius ** 2:
			var new_track = _create_track(trackable)
	
	print("SENSOR TRACKS UPDATED: ", tracks)



func get_tracks(): 
	return tracks.values()


#endregion
#region private


func _create_track(trackable_area : TrackableArea):
	var track = TargetTrack.new()
	track.trackable_area = trackable_area
	tracks[trackable_area] = track
	
	print("CREATING TRACK: ", track)


#endregion
