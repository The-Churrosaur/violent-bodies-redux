
## sensor and track holder
## creates new tracks when object enters.
## evaluates track strength etc. on evaluate_tracks()

class_name Sensor
extends Area3D


@export_subgroup("Components")

@export var sensor_evaluator : SensorEvaluator

@export_subgroup("Parameters")

@export var detect_faction : LevelGlobals.FACTIONS

@onready var sensor_timer: Timer = $SensorTimer

var tracks = {} ## trackable_area -> track


#region callbacks


func _on_sensor_timer_timeout() -> void:
	update_tracks()


func _on_area_entered(area: Area3D) -> void:
	if _valid_area(area) and !tracks.has(area): _create_track(area)


func _on_area_exited(area: Area3D) -> void:
	if _valid_area(area) and tracks.has(area): tracks.erase(area) 


#endregion
#region public


func update_tracks():
	sensor_evaluator.update_tracks(tracks)

func get_tracks(): 
	return tracks.values()


#endregion
#region private


func _valid_area(area : Area3D) -> bool:
	return area is TrackableArea and area.faction == detect_faction

func _create_track(trackable_area : TrackableArea):
	var track = TargetTrack.new()
	track.trackable_area = trackable_area
	tracks[trackable_area] = track
	
	print("CREATING TRACK: ", track)


#endregion
