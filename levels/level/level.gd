
class_name Level
extends Node3D

@export var player_body : MechBody

@export var bullet_pool : VariantPool

@export var npc_manager : LevelNPCManager
@export var trackable_manager : LevelTrackableManager


func _ready():
	LevelGlobals.level = self
