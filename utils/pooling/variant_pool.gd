
## content agnostic object pool

class_name VariantPool
extends Node

@export var packed_scene: PackedScene
@export var pool_size = 500

var live_head = 0
var dead_head = 0
