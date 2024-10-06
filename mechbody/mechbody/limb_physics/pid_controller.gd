
## provides tuned outputs.
## expects to be called repeatedly by same object (logs inputs for sum/dx)
class_name PidController
extends Node


@export var p_tune = 0.5
@export var i_tune = 0.5
@export var d_tune = 0.5
@export var max_i = 10.0

## how many iterations to record, 
## area and slope calculated over this span
@export var log_size = 20

# logs error over time
var input_log = []


## returns the coefficient -
## error is actual - current
func solve(error : float) -> float:
	
	# slow but eh
	input_log.push_back(error)
	if input_log.size() > log_size: input_log.pop_front()
	
	var kp = _solve_p(error)
	var ki = _solve_i(error)
	var kd = _solve_d(error)
	
	#print("kp: ", kp)
	#print("ki: ", ki)
	#print("kd: ", kd)
	
	return kp + ki + kd


func _solve_p(error):
	return error * p_tune


func _solve_i(error):
	var sum = 0
	for i in input_log: sum += i
	return sum * i_tune / log_size



func _solve_d(error):
	
	var num_slopes = input_log.size() - 1
	if num_slopes <= 0: return 0.0
	
	var slopes = []
	slopes.resize(num_slopes)
	
	for i in range(0, num_slopes):
		var slope = input_log[i+1] - input_log[i] # / 1
		slopes[i] = slope
	
	var sum_slopes = 0
	for slope in slopes: sum_slopes += slope
	var avg_slope = sum_slopes/slopes.size()
	
	return avg_slope * d_tune
	
