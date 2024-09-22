
class_name TutorialScreen
extends Node3D


@export var label : Label3D
@export var pointer_target : Node3D

func _ready():
	pass


func activate(pointer : TutorialPointer):
	visible = true
	pointer.set_target(pointer_target)


func deactivate():
	visible = false
