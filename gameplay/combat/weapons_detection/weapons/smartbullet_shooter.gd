
class_name SmartBulletShooter
extends Shooter


@export var bullet_scene : PackedScene
@export var burst = 5
@export var burst_timer = 0.05


func fire(gunbase : GunBase):
	super(gunbase)
	
	for i in burst:
	
		var bullet = bullet_scene.instantiate()
		LevelGlobals.level.add_child(bullet)
		bullet.enable()
		
		bullet.global_transform = gunbase.muzzle.global_transform
		bullet.global_rotation = global_rotation
		bullet.launch_velocity = gunbase.launching_rigidbody.linear_velocity
		
		await get_tree().create_timer(burst_timer).timeout
