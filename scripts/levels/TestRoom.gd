extends Spatial

var rng : RandomNumberGenerator

var enemies = 1
var max_enemies = 20

const SPAWN_RANGE = {
	"min": Vector3(4,1.5,-170),
	"max": Vector3(84, 1.5,40)
}

onready var spawns = [
	$Navigation/NavigationMeshInstance/Spawn/Spawn1,
	$Navigation/NavigationMeshInstance/Spawn/Spawn2,
	$Navigation/NavigationMeshInstance/Spawn/Spawn3,
	$Navigation/NavigationMeshInstance/Spawn/Spawn4
]
onready var nav = $Navigation

onready var target = preload("res://scenes/entities/Target.tscn")
onready var enemy = preload("res://scenes/entities/Enemy.tscn")

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	EventBus.connect("target_destroyed", self, "enemy_removed")

func get_random_position(max_height = 1.5):
	return Vector3(rng.randi_range(SPAWN_RANGE.min.x,SPAWN_RANGE.max.x),rng.randi_range(SPAWN_RANGE.min.y,max_height),rng.randi_range(SPAWN_RANGE.min.z,SPAWN_RANGE.max.z))

func spawn_enemy():
	var e = enemy.instance()
	nav.add_child(e)
	e.global_transform.origin = spawns[rand_range(0, spawns.size())].global_transform.origin
	e.global_transform.origin.y = 1.5
	e.set_chasing($Player)
	enemies +=1

func enemy_removed(is_headshot):
	enemies -=1
	
func _on_Tick_timeout():
	if enemies < max_enemies:
		spawn_enemy()
