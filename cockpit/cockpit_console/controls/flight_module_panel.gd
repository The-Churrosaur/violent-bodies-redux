extends Label3D

@export var flight_module : FlightModule
@export var data_label : Label3D
@export var enabled_label : Label3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flight_module == null : return
	data_label.text = flight_module.data
	visible = flight_module.enabled
