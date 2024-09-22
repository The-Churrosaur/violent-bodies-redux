
# holds and parents mech tools

class_name MechHand
extends Node3D


@export var current_tool : MechTool
@export var arm : ArmBase
@export var other_hand : MechHand

@onready var rotation_looker = $rotation_looker

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	# keeps self parented to hand
	# just testing
	global_transform = arm.hand_reference.global_transform
	#trigger_tool()
	#scale = Vector3.ONE
	
	# testing two handed
	if other_hand != null: look_at(other_hand.global_position)


func trigger_tool():
	if current_tool != null:
		current_tool.trigger()
