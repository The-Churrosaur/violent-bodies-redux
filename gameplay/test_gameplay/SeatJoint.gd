extends JoltGeneric6DOFJoint3D

@export var body : MechBody
@export var max_speed = 100

func _physics_process(delta):
	if body.linear_velocity.length_squared() >= max_speed * max_speed:
		set_flag_x(JoltGeneric6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT_SPRING, false)
		#set_flag_y(JoltGeneric6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT_SPRING, false)
		set_flag_z(JoltGeneric6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT_SPRING, false)
	else:
		set_flag_x(JoltGeneric6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT_SPRING, true)
		#set_flag_y(JoltGeneric6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT_SPRING, true)
		set_flag_z(JoltGeneric6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT_SPRING, true)
