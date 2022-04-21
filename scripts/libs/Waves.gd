extends Node

enum State {
	WARM_UP,
	WAVE
}

var currentState = State.WARM_UP

var current_wave = 0

var warmup_time = 5
var wave_time = 10

onready var timer : Timer = $Timer

func _ready():
	timer.wait_time = warmup_time
	timer.start()
	print_debug("started %s" % timer.wait_time)

func _on_Timer_timeout():
	print_debug("timer stopped current state is %s" % currentState)
