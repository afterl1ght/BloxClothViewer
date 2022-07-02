extends Node

signal on_event_start
signal on_event_end

var event_name = "default"
var event_max_duration = 10
var event_runtime = 0
var event_running = false
var count_runtime_with_physics = false

func _run_event():
	event_running = true
	event_runtime = event_max_duration
	emit_signal("on_event_start", event_name)
	
func _update_event():
	pass
	
func _physics_event():
	pass
	
func _stop_event():
	event_runtime = 0
	event_running = false
	emit_signal("on_event_end", event_name)

func _process(delta):
	if !count_runtime_with_physics:
		if event_runtime > 0:
			_update_event()
			event_runtime -= delta
			if event_runtime <= 0:
				_stop_event()
			
		# in case event_running hasnt returned to false after event runtime is <=0
		if event_runtime <= 0 and event_running:
			_stop_event()
	else:
		if event_runtime > 0:
			_update_event()

func _physics_process(delta):
	if count_runtime_with_physics:
		if event_runtime > 0:
			_physics_event()
			event_runtime -= delta
			if event_runtime <= 0:
				_stop_event()
			
		# in case event_running hasnt returned to false after event runtime is <=0
		if event_runtime <= 0 and event_running:
			_stop_event()
	else:
		if event_runtime > 0:
			_physics_event()
