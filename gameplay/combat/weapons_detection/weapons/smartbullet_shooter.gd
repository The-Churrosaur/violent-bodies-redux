
class_name SmartBulletShooter
extends Shooter


@export var bullet_scene : PackedScene


func fire(gunbase : GunBase):
	super(gunbase)
	
	var bullet = bullet_scene.instantiate()
	LevelGlobals.level.add_child(bullet)
	bullet.enable()
	
	bullet.global_transform = gunbase.muzzle.global_transform
	bullet.global_rotation = global_rotation
	bullet.launch_velocity = gunbase.launching_rigidbody.linear_velocity
