
## half of an object pool, pre-heats prefabs but doesn't do anything about them after.
## amortizes spawning costs.
## jk is also a pool now.
## WARNING no error checking for overdrawing pool.

class_name VariantReservoir
extends Node

@export var pool = true # else reservoir
@export var prefab : PackedScene
@export var num_copies = 5
@export var spawn_copies = true
@export var pop_active_nodes = false # will not return new nodes if pool is at capacity
@onready var timer = $Timer

var count = 0
var index = -1
var head : ListNode
var tail : ListNode


func _ready():
	var node = _new_node()
	head = node
	tail = node
	count = 1
	timer.start()


func _on_timer_timeout():
	if count <= num_copies: 
		push()
		timer.start()


func push(node = null):
	if !node: node = _new_node()
	tail.next = node
	tail = node
	count += 1


func push_new(variant):
	var node = _new_node(variant)
	push(node)


func pop():
	
	if count <= 1: push()
	
	var node = head
	
	# do nothing if pool is at capacity
	if node.active and !pop_active_nodes: 
		print("POOL EMPTY: ", self)
		return
	
	head = node.next
	node.active = true
	
	count -= 1
	
	if pool:
		push(node)
		index = node.index
	
	return node.data


func _new_node(data = null):
	var node = ListNode.new()
	if !data: data = prefab.instantiate()
	node.data = data
	node.index = count
	return node
