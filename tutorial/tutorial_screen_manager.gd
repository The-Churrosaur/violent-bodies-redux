
class_name TutorialScreenManager
extends Node3D


@export var screens : Array[TutorialScreen]
@export var index = 0
@export var action_enabled = false
@export var forward_action = "ax_button"
@export var back_action = "by_button"
@export var pointer : TutorialPointer


func _ready():
	screens[index].activate(pointer)
	XRPlayerGlobals.controller_input_pressed.connect(_on_controller_input_pressed)


func _on_controller_input_pressed(action : String, controller : XRController3D):
	if !action_enabled: return
	if action == forward_action: move_forward()
	if action == back_action: move_back()


func move_forward():
	screens[index].deactivate()
	if index >= screens.size() - 1: 
		close()
		return
	if index < screens.size() - 1: index += 1
	screens[index].activate(pointer)


func move_back():
	screens[index].deactivate()
	if index > 0: index -= 1
	screens[index].activate(pointer)


func open():
	visible = true

func close():
	visible = false


func _on_backbutton_button_clicked():
	move_back()


func _on_forbutton_button_clicked():
	move_forward()
