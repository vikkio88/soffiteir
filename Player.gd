extends KinematicBody

var speed = 7
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var jump = 5

var cam_accel = 40
var mouse_sense = 0.1
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera
onready var muzzle = $Head/Camera/Hand/Gun/Muzzle
onready var cameraAnim = $Head/Camera/AnimationPlayer
onready var gunAnim = $Head/Camera/Hand/Gun/AnimationPlayer

onready var bullet = preload("res://Bullet.tscn")

var is_on_ads = false
var rng = RandomNumberGenerator.new()

func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cameraAnim.play("Headbob")

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * get_mouse_sense()))
		head.rotate_x(deg2rad(-event.relative.y * get_mouse_sense()))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform

func get_speed():
	if not is_on_ads:
		return speed
	
	return speed * .4

func get_mouse_sense():
	if not is_on_ads:
		return mouse_sense
	
	return mouse_sense / 2

func get_jump_force():
	if not is_on_ads:
		return jump
	
	return jump * .7

func set_ads(value:bool):
	is_on_ads = value
		
func _physics_process(delta):
	if Input.is_action_just_pressed("fire"):
		var b = bullet.instance()
		get_tree().get_root().add_child(b)
		b.global_transform = muzzle.global_transform
		b.shoot()
		gunAnim.play("shoot")
		head.rotation.x += (randi() % (5 if is_on_ads else 10)) / 100.0
	
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * get_jump_force()
	
	#make it move
	velocity = velocity.linear_interpolate(direction * get_speed(), accel * delta)
	movement = velocity + gravity_vec
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	if direction != Vector3.ZERO:
		cameraAnim.play("Headbob")
