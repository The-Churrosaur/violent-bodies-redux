
class_name PoolableComponent
extends Node3D


var base : Node3D
var pool : VariantReservoir 


## call this from base
func re_pool():
	pool.push_new(base)
