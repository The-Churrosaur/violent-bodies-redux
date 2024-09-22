
class_name ProjectilePathUI
extends Node3D

@export var segments = 10
@export var timestep = 0.1
@export var projectile_pip : PackedScene
@export var lead_computer : LeadComputer

@onready var line_drawer_3d : LineDrawer3D = %LineDrawer3d

var points_array : Array[Vector3] = [segments]
var pips = []


func _ready():
	points_array.resize(segments)
	
	for i in segments:
		var pip = projectile_pip.instantiate()
		add_child(pip)
		pips.append(pip)


func _process(delta):
	draw_path()


func draw_path():
	
	for i in segments:
		var point = lead_computer.get_time_lead(i * timestep)
		points_array[i] = point
		#line_drawer_3d.points.append(point)
		
		pips[i].global_position = point
		#print(pips[i].position)
		#print(global_position)
		
		if i > 0: pips[i].look_at(pips[i-1].global_position)
	
	#line_drawer_3d.points = points_array
	#line_drawer_3d.draw()
