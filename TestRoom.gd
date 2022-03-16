extends Spatial

var rng : RandomNumberGenerator

var enemies = 1
var max_enemies = 5


onready var target = preload("res://Target.tscn")

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	EventBus.connect("target_destroyed", self, "enemy_removed")

func get_random_position(max_height = 1.5):
	return Vector3(rng.randi_range(4,84),rng.randi_range(1.5,max_height),rng.randi_range(-170,40))

func spawn_enemy():
	var t = target.instance()
	add_child(t)
	t.global_transform.origin = get_random_position()
	enemies +=1

func enemy_removed(is_headshot):
	enemies -=1
	
func _on_Tick_timeout():
	if enemies < max_enemies:
		spawn_enemy()
