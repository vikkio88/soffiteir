extends RigidBody


const DAMAGE = 50
const SPEED = .5

onready var hole = preload("res://BulletHole.tscn")
onready var ray = $RayCast

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	if ray.is_colliding():
		print_debug("collided")
		var collisionbody = ray.get_collider()
		var bulletHole = hole.instance()
		collisionbody.add_child(bulletHole)
		bulletHole.global_transform.origin = ray.get_collision_point()
		bulletHole.look_at(ray.get_collision_point() - ray.get_collision_normal() , Vector3.UP)
		if collisionbody.is_in_group("Enemy"):
			#body.health -= DAMAGE
			print_debug("%s hit enemy" % OS.get_unix_time())
			EventBus.emit_signal("target_hit", ray.get_collision_point())
			queue_free()
		else:
			print_debug("%s missed" % OS.get_unix_time())
			queue_free()
func shoot():
	var forward_dir = global_transform.basis.z.normalized()
	apply_impulse(-forward_dir, forward_dir * SPEED)
	$Timer.start()


func _on_Timer_timeout():
	print_debug("didn't hit anything, removed: %s" % global_transform.origin)
	queue_free()
