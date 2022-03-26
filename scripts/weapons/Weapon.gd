extends Spatial

class_name Weapon

export var HandPath:NodePath

onready var bullet = preload("res://scenes/entities/Bullet.tscn")

var is_bolt_action = true

var bullet_speed = 1
var bullet_damage = 10

var ads_speed = 20
var ads_fov = 45

var can_fire = true
var reloading = false
var blocked = false

var type = WeaponEnums.TYPES.NONE

var bullets = 0

var starting_bullets = 0

var Hand:Node

func first_mag():
	bullets = starting_bullets

func register_shot():
	bullets -= 1
	if bullets < 0:
		bullets = 0
	
	if bullets == 0:
		can_fire = false
	mag_update()

func is_reloading()-> bool:
	return reloading

func can_shoot() -> bool:
	return can_fire and not is_reloading() and not blocked
	
func load_magazine(ammo):
	perform_reload(ammo)

func loaded_magazine(ammo):
	bullets = ammo
	can_fire = true
	mag_update()

func mag_update():
	EventBus.emit_signal("mag_update", type, bullets, starting_bullets)

func has_bullets_left() -> bool:
	return bullets > 0
	
func get_recoil(is_on_ads:bool) -> float:
	var maxVal = (5 if is_on_ads else 10)
	var minVal = (2 if is_on_ads else 5)
	return ((randi() % maxVal) + minVal) / 100.0

func perform_shot(delta,is_on_ads: bool):
	# left to implement to each weapon
	pass

func empty_mag():
	# click if mag is empty
	pass

func perform_reload(ammo):
	# left to implement as an animation?
	# to call this after finished
	loaded_magazine(ammo)
	
func shoot(delta,is_on_ads: bool)-> float:
	if not has_bullets_left():
		empty_mag()
		return 0.0
		
	if not can_shoot():
		return 0.0
	perform_shot(delta, is_on_ads)
	
	return get_recoil(is_on_ads)

func move_away():
	can_fire = false
	blocked = true
	print_debug("moving away")

func reset_position():
	can_fire = true
	blocked = true
	print_debug("resetting")
