extends Weapon

onready var muzzle = $Gun/Muzzle
onready var anim = $Animation
onready var hitscanner = $Gun/Muzzle/CloseHit

onready var shootingSound = $Shooting
onready var rechamberingSound = $Rechambering
onready var noAmmoSound = $NoAmmo
onready var reloadSound = $Reload

var temp_ammo = 0

func _ready():
	Hand = get_node(HandPath)
	bullet_damage = 50
	ads_speed = 10
	type = WeaponEnums.TYPES.SNIPER
	starting_bullets = 5
	first_mag()
		

func empty_mag():
	if not noAmmoSound.is_playing():
		noAmmoSound.play()

func perform_reload(ammo):
	reloading = true
	temp_ammo = ammo
	anim.play("Reload")

func perform_shot(delta,is_on_ads: bool):
	var b = bullet.instance()
	get_tree().get_root().add_child(b)
	
	if hitscanner.is_colliding():
		b.hit(hitscanner, bullet_damage)
	else:
		b.shoot_from(muzzle.global_transform, bullet_speed, bullet_damage)
		
	var scale = rand_range(.7,1)
	shootingSound.set_pitch_scale(scale)
	rechamberingSound.set_pitch_scale(scale)
	anim.play("Shoot")
	can_fire = false

func _on_Animation_animation_finished(anim_name):
	match anim_name:
		"Shoot":
			register_shot()
			if has_bullets_left():
				anim.play("Rechamber")
		"Rechamber":
			can_fire = true
			if temp_ammo > 0:
				loaded_magazine(temp_ammo)
				temp_ammo = 0
				# rechambers after reload
				reloading = false
		"ResetPosition":
			blocked = false
			if has_bullets_left():
				can_fire = true
		"Reload":
			anim.play("Rechamber")


func move_away():
	can_fire = false
	blocked = true
	if reloading:
		Hand.update_mags(type, +1)
		temp_ammo = 0
		reloading = false
	anim.play("MoveAway")

func reset_position():
	anim.play("ResetPosition")

