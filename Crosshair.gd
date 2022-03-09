extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("target_hit", self, "report_hit")

func report_hit(position):
	visible = false
	$Timer.start()


func _on_Timer_timeout():
	visible = true
