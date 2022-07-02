extends Control

class_name Overlay

var colorRectAlpha8 = 100 # out of 255

var fadeDuration = 0.25
var currentFadeTime = 0.25

var uiEnabled = false

func activate(colorRectA8 = 100):
	colorRectAlpha8 = colorRectA8
	uiEnabled = true

func deactivate():
	uiEnabled = false

func _process(dt):
	
	if !uiEnabled:
		if currentFadeTime <= 0:
			visible = false
		else:
			currentFadeTime -= dt
	else:
		if !(visible):
			visible = true
		
		if (currentFadeTime < fadeDuration):
			currentFadeTime += dt
	
	currentFadeTime = clamp(currentFadeTime, 0, fadeDuration)
	modulate.a = currentFadeTime / fadeDuration
	$ColorRect.modulate.a8 = colorRectAlpha8
