extends "res://scripts/weapons/Weapon.gd"

onready var muzzle = $Gun/Muzzle
onready var anim = $Animation

func _ready():
	bullet_damage = 50
	ads_speed = 10

func shoot(delta,is_on_ads: bool)-> float:
	var b = bullet.instance()
	get_tree().get_root().add_child(b)
	b.shoot_from(muzzle.global_transform, bullet_speed, bullet_damage)
	anim.play("Shoot")
	
	is_ready = false
	
	return get_recoil(is_on_ads)


func _on_Animation_animation_finished(anim_name):
	match anim_name:
		"Shoot":
			anim.play("Rechamber")
		"Rechamber":
			is_ready = true
			
