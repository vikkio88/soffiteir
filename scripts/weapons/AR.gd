extends Weapon

onready var muzzle = $Gun/Muzzle
onready var hitscanner = $Gun/Muzzle/CloseHit

onready var anim = $Animation
onready var shootingSound = $Shooting
onready var noAmmoSound = $NoAmmo

var temp_ammo = 0

func _ready():
	Hand = get_node(HandPath)
	is_bolt_action = false
	type = WeaponEnums.TYPES.AR
	starting_bullets = 25
	bullet_damage = 25
	first_mag()

func empty_mag():
	if not noAmmoSound.is_playing():
		noAmmoSound.play()

func get_recoil(is_on_ads:bool) -> float:
	var maxVal = (5 if is_on_ads else 10)
	var minVal = (2 if is_on_ads else 5)
	return ((randi() % maxVal) + minVal) / 200.0

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
	
	can_fire = false
	shootingSound.set_pitch_scale(rand_range(.9,1.2))
	anim.play("Shoot")

func _on_Animation_animation_finished(anim_name):
	match anim_name:
		"Shoot":
			can_fire = true
			register_shot()
		"ResetPosition":
			blocked = false
			if has_bullets_left():
				can_fire = true
		"Reload":
			loaded_magazine(temp_ammo)
			temp_ammo = 0
			reloading = false
			can_fire = true


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

