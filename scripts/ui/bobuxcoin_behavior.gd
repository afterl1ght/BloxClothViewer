extends BasicPhysicsObject2D

export(bool) var isPersistent = false
var existInSeconds = 8
var fadeDuration = 1 # must lower than existInSeconds

var currentExistTimer = 0

func _process(dt):
	if isPersistent:
		return
	
	currentExistTimer += dt
	
	if fadeDuration != 0:
		if (currentExistTimer >= (existInSeconds - fadeDuration)):
			# start fading
			modulate.a = clamp((existInSeconds - currentExistTimer) / fadeDuration, 0, 1)
	
	if (currentExistTimer >= existInSeconds):
		visible = false
		queue_free()
