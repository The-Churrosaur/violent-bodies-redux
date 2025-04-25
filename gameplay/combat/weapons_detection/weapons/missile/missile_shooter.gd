extends Shooter


@export var missile_scene : PackedScene


func fire(gunbase):
	super(gunbase)
	
	var missile : Missile = missile_scene.instantiate()
	LevelGlobals.level.add_child(missile)
	missile.global_transform = gunbase.muzzle.global_transform
	
	missile.fire_missile(target)
