extends TextureButton

export(NodePath) var uiNodePath
onready var uiNode : Control = get_node(uiNodePath)

var fadeDuration = 0.25
var currentFadeTime = 0.25

var isPressed = false
var uiEnabled = true

func _pressed():
	isPressed = true
	if !uiEnabled:
		modulate.a = 1
	else:
		modulate.a = 0.25

func _process(dt):
	var justSwitched = false
	if isPressed:
		justSwitched = true
		isPressed = false
		uiEnabled = !uiEnabled
		
	if !uiEnabled:
		if currentFadeTime <= 0:
			if uiNode:
				uiNode.visible = false
		else:
			currentFadeTime -= dt
	else:
		if uiNode:
			if !(uiNode.visible):
				uiNode.visible = true
		
		if (currentFadeTime < fadeDuration):
			currentFadeTime += dt
	
	currentFadeTime = clamp(currentFadeTime, 0, fadeDuration)
	uiNode.modulate.a = currentFadeTime / fadeDuration
