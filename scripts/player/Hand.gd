extends Spatial

var ads_lerp = 20
export var default_pos : Vector3
export var ads_pos : Vector3

var mouse_move
var sway_threshold = 20
var sway_lerp = 10
var sway_lerp_ads = 5

export var sway_left: Vector3
export var sway_right: Vector3
export var sway_normal: Vector3


var fview = {
	"default": 70,
	"ads": 45,
}

var magazines = {
	WeaponEnums.TYPES.AR: {"count": 5, "ammo":25, "max": 5},
	WeaponEnums.TYPES.SNIPER: {"count":5, "ammo":5, "max": 5}
}

export var camera_node_path : NodePath
export var player_node_path : NodePath
var camera: Camera
var player: Node
var previous_ads = 0

onready var sniper = $SniperRifle
onready var ar = $AR

onready var activeWeapon = $SniperRifle


func _ready():
	camera = get_node(camera_node_path)
	player = get_node(player_node_path)
	fview["default"] = camera.fov
	ads_lerp = activeWeapon.ads_speed
	call_deferred('init_hud')
	EventBus.connect("mags_pickup", self, "picked_mag")
	
	
func init_hud():
	activeWeapon.mag_update()
	EventBus.emit_signal("weapon_switch", activeWeapon.type)
	EventBus.emit_signal("player_mags_update", magazines)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_move = -event.relative.x

func switch_weapon(index: int):
	match index:
		WeaponEnums.TYPES.SNIPER:
			ar.visible = false
			sniper.visible = true
			activeWeapon = sniper
		WeaponEnums.TYPES.AR:
			ar.visible = true
			sniper.visible = false
			activeWeapon = ar
	
	ads_lerp = activeWeapon.ads_speed
	
	EventBus.emit_signal("weapon_switch", activeWeapon.type)
	activeWeapon.mag_update()

func reload():
	if activeWeapon.blocked:
		print_debug("weapon is blocked")
		return
		
	if magazines[activeWeapon.type].count < 1:
		print_debug("no more mag for type %s" % activeWeapon.type)
		return
	
	if activeWeapon.is_reloading():
		print_debug("cannot reload while reloading")
		return
	
	activeWeapon.load_magazine(magazines[activeWeapon.type].ammo)
	update_mags(activeWeapon.type, -1)

func update_mags(type, diff):
	magazines[type].count += diff
	EventBus.emit_signal("player_mags_update", magazines)

func picked_mag(quantity, mag_type):
	var weaponType = mag_type if mag_type != WeaponEnums.TYPES.NONE else activeWeapon.type
	# need to check when we pickup more than one at the time we only get 1
	if magazines[weaponType].count + quantity > magazines[weaponType].max:
		return
		
	update_mags(weaponType, quantity)

func _process(delta):
	if Input.is_action_pressed("ads"):
		transform.origin = transform.origin.linear_interpolate(ads_pos, ads_lerp * delta)
		camera.fov =  lerp(camera.fov, fview["ads"], ads_lerp * delta)
		player.set_ads(true)
	else:
		transform.origin = transform.origin.linear_interpolate(default_pos, ads_lerp * delta)
		camera.fov =  lerp(camera.fov, fview["default"], ads_lerp * delta)
		player.set_ads(false)
	
	var on_ads = player.is_on_ads
	if mouse_move != null:
		var sway = (sway_lerp_ads if on_ads else sway_lerp) * delta
		if mouse_move > sway_threshold:
			rotation = rotation.linear_interpolate(sway_left, sway)
		elif mouse_move < -sway_threshold:
			rotation = rotation.linear_interpolate(sway_right, sway)
		else:
			rotation = rotation.linear_interpolate(sway_normal, sway)

func has_bolt_action() -> bool:
	return activeWeapon.is_bolt_action

func shoot_weapon(delta) -> float:
	return activeWeapon.shoot(delta, player.is_on_ads)


func _on_WeaponBounds_body_entered(body):
	if body.is_in_group("Player"):
		return
	activeWeapon.move_away()


func _on_WeaponBounds_body_exited(body):
	if body.is_in_group("Player"):
		return
	activeWeapon.reset_position()
