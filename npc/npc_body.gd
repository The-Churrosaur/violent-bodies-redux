

## npc interface with the world
class_name NPCBody
extends RigidBody3D


signal death

@export var controller : NPCController
@export var faction : LevelGlobals.FACTIONS


func _ready() -> void:
	register()


## registers with npc manager
func register():
	var level : Level = LevelGlobals.level
	if level : level.npc_manager.register_npc(self)


## unsubscribes from npc manager etc
func die():
	print("npc die()ing...", self)
	death.emit()
	var level : Level = LevelGlobals.level
	if level : level.npc_manager.deregister_npc(self)
	queue_free()
