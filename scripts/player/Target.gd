extends RigidBody

onready var Head = $HeadShape
onready var anim = $Animation
onready var timer = $Timer

var health = 100

func receive_damage(dmg, hit_point):
	if health == 0:
		return
	
	var distance_from_head = hit_point.distance_to(Head.global_transform.origin)
	var is_headshot = false
	if distance_from_head < .58:
		print_debug("HEADSHOT")
		is_headshot = true
		dmg = 90 - dmg if dmg < 30 else dmg * 2
		
	health-=dmg
	health = 0 if health < 0 else health
	if health == 0:
		EventBus.emit_signal("target_destroyed", is_headshot)
		EventBus.emit_signal("target_damaged", dmg, is_headshot)
		timer.start()
		anim.play("Death")
	else:
		EventBus.emit_signal("target_damaged", dmg, is_headshot)


func _on_Timer_timeout():
	queue_free()
