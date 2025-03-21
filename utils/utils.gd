
class_name Utils
extends Node


## vector helpers


static func compare_vectors(a: Vector3, b : Vector3, epsilon = 0.001):
	#print("comparing: ", (a-b).length_squared())
	return (a - b).length_squared() < epsilon
