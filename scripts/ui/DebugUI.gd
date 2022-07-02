extends Control

class_name DebugUI

#onready var is_debug = OS.is_debug_build()
var is_init = false

func _process(_dt):
	if (!is_init):
		is_init = true
		if (OS.is_debug_build()):
			var versionName = ProjectSettings.get_setting("application/config/version_name")
			var buildPhase = ProjectSettings.get_setting("application/config/build_phase")
			if !versionName:
				versionName = "UNKNOWN (malfunctioned metadata?)"
			print(versionName)
			print(buildPhase)
			$version.text = str(versionName) + " (Build Phase " + str(buildPhase) + ")"
		else:
			visible = false
