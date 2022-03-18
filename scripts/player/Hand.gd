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

func _input(event):
	if event is InputEventMouseMotion:
		mouse_move = -event.relative.x

func switch_weapon(index: int):
	match index:
		1:
			ar.visible = false
			sniper.visible = true
			activeWeapon = sniper
		2:
			ar.visible = true
			sniper.visible = false
			activeWeapon = ar
	
	ads_lerp = activeWeapon.ads_speed

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
	if activeWeapon.can_fire:
		return activeWeapon.shoot(delta, player.is_on_ads)
	else:
		return .0


func _on_WeaponBounds_body_entered(body):
	activeWeapon.move_away()


func _on_WeaponBounds_body_exited(body):
	activeWeapon.reset_position()
