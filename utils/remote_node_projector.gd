
## projects a visual copy of all given child nodes under projection_reference
class_name RemoteNodeProjector
extends Node3D


## will project relative to self here
@export var projection_reference : Marker3D

## will project these WARNING assumes these nodes are children (for maximum accuracy)
@export var project_children: Array[Node3D]


# copy of project. Assumes these two are synced
var _projection_targets : Array[Node3D]
var _projections : Array[Node3D]


# ----- CALLBACKS -----


func _ready():
	update_projections()


func _process(delta):
	
	for i in _projection_targets.size():
		
		var target = _projection_targets[i]
		var projection = _projections[i]
		
		# again - assuming projection target nodes are direct chidren
		projection.transform = target.transform


# ----- PUBLIC -----


## uses duplicate(), so will only consider properties considered by duplicate()
func update_projections():
	_projection_targets = project_children
	
	# delete current projections
	for projection in _projections:
		projection.queue_free()
	_projections.clear()
	
	# instantiate new projections under remote
	for target in _projection_targets:
		var projection = target.duplicate()
		_projections.append(projection)
		projection_reference.add_child(projection)
