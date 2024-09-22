
class_name MyXRHandGrabber
extends Node3D

@export var controller : XRController3D
@export var grab_area : Area3D
@export var hold_reference : Node3D


var detected_grabbable : MyXRGrabbable = null
var hovering = false ## currently hovering detected_grabbable
var grabbed_grabbable : MyXRGrabbable = null
var grabbing = false ## currently grabbing grabbed_grabbable



# CALLBACKS --------------------------------------------------------------------



# -- GODOT CALLBACKS


func _ready():
	
	# connect signals
	
	if controller != null:
		controller.button_pressed.connect(_on_controller_button_pressed)
		controller.button_released.connect(_on_controller_button_released)
	
	grab_area.body_entered.connect(_on_grab_area_body_entered)
	grab_area.body_exited.connect(_on_grab_area_body_exited)


# -- SIGNAL CALLBACKS


func _on_controller_button_pressed(action):
	
	# grab detected grabbable or release grabbed grabbable
	
	if action == "grip_click": 
		# grab
		if (detected_grabbable != null) and (grabbed_grabbable == null): 
			_grab_detected_grabbable()
		#drop
		elif grabbed_grabbable != null: 
			_drop_grabbable()
		# twiddle thumbs
		else: 
			pass


func _on_controller_button_released(action):
	
	# drop grabbable if it has drop_on_release true
	
	if action == "grip_click":
		if (grabbed_grabbable != null) and (grabbed_grabbable.drop_on_release):
			_drop_grabbable() 


func _on_grab_area_body_entered(body):
	if grabbed_grabbable != null: return
	if (body is MyXRGrabbable) and (detected_grabbable == null):
		detected_grabbable = body
		detected_grabbable.hover_me(self)


func _on_grab_area_body_exited(body):
	if body == detected_grabbable: 
		detected_grabbable.release_hover_me(self)
		detected_grabbable = null



# PUBLIC -----------------------------------------------------------------------


func force_grab(grabbable : MyXRGrabbable):
	detected_grabbable = grabbable
	_grab_detected_grabbable()


# PRIVATE ----------------------------------------------------------------------



func _grab_detected_grabbable():
	_release_hover()
	detected_grabbable.grab_me(self)
	grabbed_grabbable = detected_grabbable
	detected_grabbable = null


func _drop_grabbable():
	if grabbed_grabbable.ignore_drop: return
	grabbed_grabbable.drop_me(self)
	# dropped to hover
	detected_grabbable = grabbed_grabbable
	_hover_detected_grabbable()
	grabbed_grabbable = null


func _hover_detected_grabbable():
	detected_grabbable.hover_me(self)
	hovering = true


func _release_hover():
	if !hovering : return
	detected_grabbable.release_hover_me(self)
	hovering = false
