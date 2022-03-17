extends Label

func _ready():
	EventBus.connect("target_hit", self, "report_hit")

func report_hit():
	text = "HIT"
	$Timer.start()


func _on_Timer_timeout():
	text = ""
