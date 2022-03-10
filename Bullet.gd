extends RigidBody


const DAMAGE = 50
const SPEED = .9

onready var hole = preload("res://BulletHole.tscn")
onready var rayFront = $RayCastFront
onready var rayDown = $RayCastDown
onready var rayUp = $RayCastUp

var starting_point = Vector3.ZERO

func _ready():
	starting_point = transform.origin
	set_as_toplevel(true)

func check_hit(ray):
	if ray.is_colliding():
		print_debug("collided")
		var collisionbody = ray.get_collider()
		var bulletHole = hole.instance()
		collisionbody.add_child(bulletHole)
		bulletHole.global_transform.origin = ray.get_collision_point()
		bulletHole.look_at(ray.get_collision_point() - ray.get_collision_normal() , Vector3.UP)
		if collisionbody.is_in_group("Enemy"):
			var hit_distance = ray.get_collision_point().distance_to(starting_point)
			print_debug("%s hit enemy" % OS.get_unix_time())
			if collisionbody.has_method("receive_damage"):
				collisionbody.receive_damage(DAMAGE, ray.get_collision_point())
			EventBus.emit_signal("target_hit", hit_distance)
			return true
		else:
			print_debug("%s missed" % OS.get_unix_time())
			return true
		
		return false
			

func _physics_process(delta):
	var hit = check_hit(rayFront)
	if hit:
		queue_free()
		return
		
	hit = check_hit(rayUp)
	if hit:
		queue_free()
		return
		
	hit = check_hit(rayDown)
	if hit:
		queue_free()
		return
		
	
#	if rayDown.is_colliding():
#		ray = rayDown
#	elif rayUp.is_colliding():
#		ray = rayUp
	
	
func shoot_from(muzzle_transform):
	global_transform = muzzle_transform
	starting_point = global_transform.origin
	var forward_dir = global_transform.basis.z.normalized()
	apply_impulse(-forward_dir, forward_dir * SPEED)
	$Timer.start()


func _on_Timer_timeout():
	print_debug("didn't hit anything, removed: %s" % global_transform.origin)
	queue_free()
