extends RayCast

var current_interactable = null

func _physics_process(delta):
	interactable_check()
	
func interactable_check():
	var collider = get_collider()
	if is_colliding() and collider is Interactable:
		if current_interactable != collider:
			current_interactable = collider
			collider.trigger()
			print_debug("Interaction possible")
		if Input.is_action_just_pressed("interact"):
			collider.interact()
	elif current_interactable:
		current_interactable.reset()
		current_interactable = null
