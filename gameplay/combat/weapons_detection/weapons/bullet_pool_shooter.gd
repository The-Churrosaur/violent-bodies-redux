

## fires smartbullets from a varient reservoir/pool

class_name BulletPoolShooter
extends Shooter


@export_subgroup("Components")

@export var variant_pool : VariantReservoir
@export var muzzle : Marker3D

@export_subgroup("Parameters")


func fire(gunbase : GunBase):
	super(gunbase)
	
	var bullet = variant_pool.pop()
	if !bullet: return
	#bullet.reparent(gunbase.bullet_parent)
	gunbase.bullet_parent.add_child(bullet)
	bullet.enable()
	
	bullet.global_transform = muzzle.global_transform
	bullet.global_rotation = global_rotation
	bullet.launch_velocity = gunbase.launching_rigidbody.linear_velocity
	
