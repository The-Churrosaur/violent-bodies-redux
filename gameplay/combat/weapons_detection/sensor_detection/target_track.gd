
class_name TargetTrack
extends RefCounted

enum TRACK_QUALITY {LOW, HIGH}

var trackable_area : TrackableArea
var track_quality : TRACK_QUALITY


func setup(trackable_area, track_quality = TRACK_QUALITY.HIGH):
	self.trackable_area = trackable_area
	self.track_quality = track_quality
