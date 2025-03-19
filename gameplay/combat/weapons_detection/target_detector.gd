

## filters area detection to bodies in detected_groups
class_name TargetDetector
extends Area3D


@export var detect_factions: Array[LevelGlobals.FACTIONS]


signal target_entered(targetable : TrackableArea)
signal target_exited(targetable : TrackableArea)


func _on_area_entered(area: Area3D) -> void:
	if area is not TrackableArea: return
	for faction in detect_factions: if area.faction == faction: target_entered.emit(area)


func _on_area_exited(area: Area3D) -> void:
	if area is not TrackableArea: return
	for faction in detect_factions: if area.faction == faction: target_entered.emit(area)
