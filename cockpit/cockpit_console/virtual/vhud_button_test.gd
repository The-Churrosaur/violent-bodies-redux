class_name VHUDTestButton
extends VHUDButtonTap

@export var tool_manager : MechHandToolManager
@export var weapon_label : Label3D

func _on_button_clicked():
	print("vhud button clicked")
	tool_manager.next_tool()
	weapon_label.text = tool_manager.current_tool.tool_name


func _process(delta):
	if tool_manager == null: return
	if tool_manager.current_tool == null: return
	weapon_label.text = tool_manager.current_tool.tool_name
