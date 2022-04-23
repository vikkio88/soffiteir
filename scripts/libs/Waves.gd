extends Node

enum State {
	WARM_UP,
	WAVE,
	FINISHED_WAVE
}

var state = State.WARM_UP

var current_wave = 0

var warmup_time = 5
var wave_time = 10

var enemies = 0
var max_enemies = 20

var enemy_increment = .25

onready var timer : Timer = $Timer
onready var tick : Timer = $Tick

func _ready():
	start_warmup()

func report_enemy_change(diff):
	print_debug("report enemy ", diff)
	enemies += diff
	enemies = enemies if enemies > 0 else 0
	
	if enemies < 3 and enemies > 0 and state == State.FINISHED_WAVE:
		EventBus.emit_signal("game_event", "Enemies %d / %d" % [enemies,max_enemies])

func should_spawn():
	return state == State.WAVE and enemies < max_enemies

func start_warmup():
	state = State.WARM_UP
	timer.wait_time = warmup_time
	timer.start()
	EventBus.emit_signal("game_event", "Warmup started")

func start_wave():
	max_enemies = int((current_wave * enemy_increment) * max_enemies + max_enemies)
	current_wave += 1
	state = State.WAVE
	timer.wait_time = wave_time
	timer.start()
	EventBus.emit_signal("game_event", "Wave %d started" % current_wave)

func check_end_wave():
	print_debug('end wave check ', enemies)
	state = State.FINISHED_WAVE
	if enemies == 0:
		start_warmup()
		return
	tick.start()
	
	
	
	

# State machine would do wonders here
func _on_Timer_timeout():
	match state:
		State.WARM_UP:
			start_wave()
		State.WAVE:
			check_end_wave()


func _on_Tick_timeout():
	if state == State.FINISHED_WAVE:
		check_end_wave()
