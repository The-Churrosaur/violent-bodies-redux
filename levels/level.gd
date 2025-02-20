
class_name Level
extends Node3D

@export var pools: Array[VariantPool]


func _ready():
	LevelGlobals.level = self
