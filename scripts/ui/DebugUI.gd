extends Control

class_name DebugUI

#onready var is_debug = OS.is_debug_build()
var is_init = false

# returns true if luma is over half
func lumacheck(col : Color):
	var kr = 0.299
	var kg = 0.587 
	var kb = 0.114
	var y = sqrt(kr*col.r*col.r + kg*col.g*col.g + kb*col.b*col.b)
	return y#(y > 0.51)

func _process(_dt):
	#if (!is_init):
		is_init = true
		#if (OS.is_debug_build()):
		var versionName = ProjectSettings.get_setting("application/config/version_name")
		var buildPhase = ProjectSettings.get_setting("application/config/build_phase")
		if !versionName:
			versionName = "UNKNOWN (malfunctioned metadata?)"
		#print(versionName)
		#print(buildPhase)
		$version.text = str(versionName) + " (Build Phase " + str(buildPhase) + ")\n" + str(Performance.get_monitor(Performance.TIME_FPS)) + " FPS"
		$version.modulate = lerp(Color(1,1,1,0.2),Color(0.1,0.1,0.1,0.2),min(lerp(0, 2, lumacheck(Preloader.fakeskymat.get_shader_param("albedo"))), 1))
		#else:
		#	visible = false
