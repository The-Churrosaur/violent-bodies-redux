

## npc interface with the world
class_name NPCBody
extends RigidBody3D


signal death

@export var controller : NPCController


func _ready() -> void:
	register()


## registers with npc manager
func register():
	var level : Level = LevelGlobals.level
	if level : level.npc_manager.register_npc(self)


## unsubscribes from npc manager etc
func cleanup():
	print("npc die()ing...", self)
	death.emit()
	var level : Level = LevelGlobals.level
	if level : level.npc_manager.deregister_npc(self)
	queue_free()
