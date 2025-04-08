
class_name PoolbulletShooter
extends Shooter

@export var damage = 1.0


func fire(gunbase : GunBase):
	super(gunbase)
	
	var bullet : PoolBullet = LevelGlobals.level.bullet_pool.pop()
	if !bullet.get_parent(): LevelGlobals.level.add_child(bullet)
	bullet.enable()
	bullet.set_damage(damage)
	
	bullet.global_transform = gunbase.muzzle.global_transform
	bullet.global_rotation = global_rotation
	bullet.launch_velocity = gunbase.launching_rigidbody.linear_velocity
