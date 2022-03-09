extends Label


export var PlayerNode: NodePath
var player: Spatial

func _ready():
	player = get_node(PlayerNode)
	EventBus.connect("target_hit", self, "report_hit")

func report_hit(position):
	text = "%d" % player.global_transform.origin.distance_to(position)
	$Timer.start()


func _on_Timer_timeout():
	text= ""
