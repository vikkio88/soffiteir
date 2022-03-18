extends Node

class_name Weapon

onready var bullet = preload("res://scenes/entities/Bullet.tscn")

var is_bolt_action = true

var bullet_speed = 1
var bullet_damage = 10

var ads_speed = 20

var can_fire = true

func get_recoil(is_on_ads:bool) -> float:
	var maxVal = (5 if is_on_ads else 10)
	var minVal = (2 if is_on_ads else 5)
	return ((randi() % maxVal) + minVal) / 100.0

func shoot(delta, is_on_ads:bool)-> float:
	return get_recoil(is_on_ads)

func move_away():
	can_fire = false
	print_debug("moving away")

func reset_position():
	can_fire = true
	print_debug("resetting")
