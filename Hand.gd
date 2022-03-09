extends Spatial

const ADS_LERP = 20
export var default_pos : Vector3
export var ads_pos : Vector3

var fview = {
	"default": 70,
	"ads": 50,
}

export var camera_node_path : NodePath
export var player_node_path : NodePath
var camera: Camera
var player: Node
var previous_ads = 0


func _ready():
	camera = get_node(camera_node_path)
	player = get_node(player_node_path)
	fview["default"] = camera.fov

func _process(delta):
	if Input.is_action_pressed("ads"):
		transform.origin = transform.origin.linear_interpolate(ads_pos, ADS_LERP * delta)
		camera.fov =  lerp(camera.fov, fview["ads"], ADS_LERP * delta)
		player.set_ads(true)
	else:
		transform.origin = transform.origin.linear_interpolate(default_pos, ADS_LERP * delta)
		camera.fov =  lerp(camera.fov, fview["default"], ADS_LERP * delta)
		player.set_ads(false)
