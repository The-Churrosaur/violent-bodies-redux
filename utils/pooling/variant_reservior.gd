
## half of an object pool, pre-heats prefabs but doesn't do anything about them after.
## amortizes spawning costs.
## jk is also a pool now.
## WARNING no error checking for overdrawing pool.
## optional contract - variant being spawned has enable(), disable() methods

class_name VariantReservoir
extends Node

@export var pool = true # else reservoir
@export var prefab : PackedScene
@export var num_copies = 100
@export var spawn_copies = true
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


func pop():
	
	if count <= 1: push()
	
	#print("popping variant out of: ", count)
	
	var node = head
	head = node.next
	
	count -= 1
	
	if pool:
		push(node)
		index = node.index
	
	node.data.enable()
	return node.data


func _new_node():
	var node = ListNode.new()
	var copy = prefab.instantiate()
	node.data = copy
	node.index = count
	if spawn_copies: 
		if copy.has_method("disable"): copy.disable()
		add_child(copy)
	return node
