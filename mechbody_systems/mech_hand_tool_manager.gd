
class_name MechHandToolManager
extends Node3D

@export var tools : Array[MechTool]
@export var input_grabbable : MyXRGrabbable
@export var hand : MechHand


var current_tool : MechTool
var current_index = 0


func _ready():
	print("toolmanager tools: ", tools)
	set_tool(0)


func set_tool(index):
	print("toolmanager setting tool: ", tools[index])
	var tool = tools[index]
	_set_tool(tool)
	current_index = index


func next_tool():
	print("toolmanager called")
	var next_index = current_index + 1
	if next_index >= tools.size(): next_index = 0
	set_tool(next_index)


func set_tool_override(tool : MechTool):
	_set_tool(tool)


#region ===== PRIVATE =====


func _set_tool(tool):
	if current_tool is MechTool: current_tool.deactivate()
	current_tool = tool
	current_tool.activate(hand, input_grabbable)


#endregion
