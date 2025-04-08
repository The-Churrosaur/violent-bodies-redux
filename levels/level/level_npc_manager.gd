class_name LevelNPCManager
extends Node3D


signal npc_registered(npc)
signal npc_deregistered(npc)

@export var npcs = {}

@export_subgroup("components")
@export var level : Level


func _ready() -> void:
	register_child_npcs()


## npcs register themselves by default, (except at startup)
func register_npc(npc : NPCBody):
	npcs[npc] = true
	print("npc registered: ", npc)


func deregister_npc(npc : NPCBody):
	npcs[npc] = false
	print("npc DEREGISTERED: ", npc)


## recursively searches children - not fast, for testing
## TODO should be by node.find_children or groups?
func register_child_npcs(node = level):
	
	for child in node.get_children():
		if child is NPCBody: register_npc(child)
		if child.get_child_count() > 0: register_child_npcs(child)


func on_npc_died(npc):
	pass
	
