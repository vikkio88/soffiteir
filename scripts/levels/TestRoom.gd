extends Spatial

var rng : RandomNumberGenerator

var enemies = 1
var max_enemies = 10

const SPAWN_RANGE = {
	"min": Vector3(4,1.5,-170),
	"max": Vector3(84, 1.5,40)
}


onready var target = preload("res://scenes/entities/Target.tscn")

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	EventBus.connect("target_destroyed", self, "enemy_removed")

func get_random_position(max_height = 1.5):
	return Vector3(rng.randi_range(SPAWN_RANGE.min.x,SPAWN_RANGE.max.x),rng.randi_range(SPAWN_RANGE.min.y,max_height),rng.randi_range(SPAWN_RANGE.min.z,SPAWN_RANGE.max.z))

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
