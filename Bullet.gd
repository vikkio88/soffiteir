extends RigidBody


const DAMAGE = 50
const SPEED = 1

#var shoot = false



# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	pass
#	if shoot:
	#	var forward_dir = global_transform.basis.z.normalized()
		#apply_impulse(transform.basis.y, transform.basis.y * SPEED)
		#global_translate(forward_dir * SPEED * delta)
	#	apply_impulse(-forward_dir, forward_dir * SPEED)
		
func shoot():
	var forward_dir = global_transform.basis.z.normalized()
	apply_impulse(-forward_dir, forward_dir * SPEED)
	$Timer.start()
		



func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		#body.health -= DAMAGE
		print_debug("%s hit enemy" % OS.get_unix_time())
		EventBus.emit_signal("target_hit", global_transform.origin)
		queue_free()
	else:
		print_debug("%s missed" % OS.get_unix_time())
		queue_free()


func _on_Timer_timeout():
	print_debug("didn't hit anything, removed: %s" % global_transform.origin)
	queue_free()
