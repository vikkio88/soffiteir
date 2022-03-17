extends "res://scripts/weapons/Weapon.gd"

onready var muzzle = $Gun/Muzzle
onready var anim = $Animation

func _ready():
	is_bolt_action = false

func get_recoil(is_on_ads:bool) -> float:
	var maxVal = (5 if is_on_ads else 10)
	var minVal = (2 if is_on_ads else 5)
	return ((randi() % maxVal) + minVal) / 200.0

func shoot(delta,is_on_ads: bool)-> float:
	var b = bullet.instance()
	get_tree().get_root().add_child(b)
	b.shoot_from(muzzle.global_transform, bullet_speed, bullet_damage)
	is_ready = false
	anim.play("Shoot")
	
	return get_recoil(is_on_ads)




func _on_Animation_animation_finished(anim_name):
	match anim_name:
		"Shoot":
			is_ready = true
