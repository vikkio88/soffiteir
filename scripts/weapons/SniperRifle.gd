extends "res://scripts/weapons/Weapon.gd"

onready var muzzle = $Gun/Muzzle
onready var anim = $Animation
onready var shootingSound = $Shooting
onready var rechamberingSound = $Rechambering

func _ready():
	bullet_damage = 50
	ads_speed = 10

func shoot(delta,is_on_ads: bool)-> float:
	var b = bullet.instance()
	get_tree().get_root().add_child(b)
	b.shoot_from(muzzle.global_transform, bullet_speed, bullet_damage)
	var scale = rand_range(.7,1)
	shootingSound.set_pitch_scale(scale)
	rechamberingSound.set_pitch_scale(scale)
	anim.play("Shoot")
	
	can_fire = false
	
	return get_recoil(is_on_ads)


func _on_Animation_animation_finished(anim_name):
	match anim_name:
		"Shoot":
			anim.play("Rechamber")
		"Rechamber":
			can_fire = true
		"ResetPosition":
			can_fire = true


func move_away():
	can_fire = false
	anim.play("MoveAway")

func reset_position():
	anim.play("ResetPosition")

