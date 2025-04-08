
## content agnostic object pool.
## NO SAFEGUARDS - JUST HOLDS OBJECTS AND CYCLES THROUGH THEM.
## MAKE IT BIG ENOUGH

class_name VariantPool
extends Node

@export var packed_scene: PackedScene
@export var pool_size = 200

var pool = []
var index = 0


func _ready() -> void:
	pool.resize(pool_size)
	for i in pool_size:
		var data = packed_scene.instantiate()
		pool[i] = data
	
	print("pool instantiated: ", pool)


func pop():
	if pool.is_empty(): return null
	var data = pool[index]
	
	index += 1
	if index >= pool_size: index = 0
	
	return data
