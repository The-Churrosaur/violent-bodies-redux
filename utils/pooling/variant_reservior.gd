
## half of an object pool, pre-heats prefabs but doesn't do anything about them after.
## amortizes spawning costs

class_name VariantReservoir
extends Node

@export var prefab : PackedScene
@export var num_copies = 20
@export var spawn_copies = true
@onready var timer = $Timer

var count = 0
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


func push():
	var node = _new_node()
	tail.next = node
	tail = node
	count += 1


func pop():
	
	if count <= 1: push()
	
	#print("popping variant out of: ", count)
	
	var node = head
	head = node.next
	count -= 1
	return node.data


func _new_node():
	var node = ListNode.new()
	var copy = prefab.instantiate()
	node.data = copy
	if spawn_copies: 
		copy.disable()
		add_child(copy)
	return node
