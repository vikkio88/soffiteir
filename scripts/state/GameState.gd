extends Node


var score = 0
var headshots = 0
var kills = 0

var longest_kill = 0

func register_kill(distance, is_headshot):
	if distance > longest_kill:
		longest_kill = distance
	
	if is_headshot:
		headshots += 1
	
	kills += 1

