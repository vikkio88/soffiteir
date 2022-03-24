extends KinematicBody


onready var Head = $HeadShape
onready var anim = $Animation
onready var timer = $Timer

var health = 100
var speed = 8.0

var move = false
var player:Spatial = null

onready var nav = get_parent()
var paths = []
var path_node = 0

func set_chasing(chasing: Spatial):
	player = chasing
	move = true

func _physics_process(delta):
	if not move or not player:
		return
	
	var dir = Vector3.ZERO
	if path_node < paths.size():
		dir = (paths[path_node] - global_transform.origin)
	if dir.length() < 1:
		path_node += 1
	else:
		move_and_slide(dir.normalized() * speed, Vector3.UP)

func move_to(point: Vector3):
	paths = nav.get_simple_path(global_transform.origin, point)
	path_node = 0

func receive_damage(dmg, hit_point):
	if health == 0:
		return
	
	var distance_from_head = hit_point.distance_to(Head.global_transform.origin)
	var is_headshot = false
	if distance_from_head < .58:
		is_headshot = true
		dmg = dmg * 2
		if dmg < 100:
			dmg = 100 if rand_range(0, 100) > 20 else dmg
		
	health-=dmg
	health = 0 if health < 0 else health
	if health == 0:
		EventBus.emit_signal("target_destroyed", is_headshot)
		EventBus.emit_signal("target_damaged", dmg, is_headshot)
		timer.start()
		move = false
		anim.play("Death")
	else:
		EventBus.emit_signal("target_damaged", dmg, is_headshot)

func _on_Timer_timeout():
	if health ==0:
		queue_free()


func _on_ViewField_body_entered(body):
	if body.is_in_group("Player"):
		move = false


func _on_ViewField_body_exited(body):
	if body.is_in_group("Player"):
		move = true


func _on_ActionTimer_timeout():
	if move and player:
		move_to(player.global_transform.origin)
