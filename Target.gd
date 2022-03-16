extends RigidBody

onready var Head = $Head/HeadShape

var health = 100

func receive_damage(dmg, hit_point):
	var distance_from_head = hit_point.distance_to(Head.global_transform.origin)
	var is_headshot = false
	if distance_from_head < .58:
		print_debug("HEADSHOT")
		is_headshot = true
		dmg *= 2
		
	health-=dmg
	health = 0 if health < 0 else health
	if health == 0:
		EventBus.emit_signal("target_destroyed", is_headshot)
		EventBus.emit_signal("target_damaged", dmg, is_headshot)
		queue_free()
	else:
		EventBus.emit_signal("target_damaged", dmg, is_headshot)
