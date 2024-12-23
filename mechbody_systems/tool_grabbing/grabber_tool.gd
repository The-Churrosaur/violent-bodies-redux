extends MechTool

@export var mechbody : MechBody

func activate(hand, controller : MyXRGrabbable = null):
	super(hand, controller)
	print("grabber activated: ", controller)


func _physics_process(delta):
	
	if tool_active:
		var trigger = grabbable_controller.controller_get_float("trigger")
		var motor = mechbody.right_hand_bit.chopstick_joint
		#joint.set_param_y(JoltGeneric6DOFJoint3D.PARAM_LINEAR_SPRING_FREQUENCY, 5 + 10 * primary.y)
		motor.set_param_x(JoltGeneric6DOFJoint3D.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, -5 + trigger * 20)
		motor.set_param_x(JoltGeneric6DOFJoint3D.PARAM_ANGULAR_MOTOR_MAX_TORQUE, 1 + trigger * 50)
		
		if trigger <= 0.05: 
			motor.set_param_x(JoltGeneric6DOFJoint3D.PARAM_ANGULAR_MOTOR_MAX_TORQUE, 10)
