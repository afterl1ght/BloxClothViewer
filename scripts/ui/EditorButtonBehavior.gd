extends TextureButton

class_name EditorButtonBehavior
const BCVEditorButtons = Globals.BCVEditorButtons

signal on_press(button_type)

export(BCVEditorButtons) var buttonType
export(NodePath) var associatedEditorPath
onready var associatedEditor = get_node(associatedEditorPath)

var tooltipPersistTime = 1
var tooltipRemainingTime = 0
var tooltipFadeTime = 1
var tooltipRemainingFadeTime = 0

var toFade = false

func setEnable():
	self_modulate.a = 1
	
	toFade = false
	tooltipRemainingTime = tooltipPersistTime
	tooltipRemainingFadeTime = tooltipFadeTime
	set_process(true)
	
	if associatedEditor:
		if associatedEditor.get_node("Tween"):
			var tween = associatedEditor.get_node("Tween")
			if tween is Tween:
				tween.stop_all()
				tween.interpolate_property(associatedEditor, "margin_left", associatedEditor.margin_left, 0, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
				tween.start()
		#associatedEditor.visible = true

func setDisable():
	self_modulate.a = 0.25
	
	toFade = true
	tooltipRemainingTime = 0
	
	if associatedEditor:
		if associatedEditor.get_node("Tween"):
			var tween = associatedEditor.get_node("Tween")
			if tween is Tween:
				tween.stop_all()
				tween.interpolate_property(associatedEditor, "margin_left", associatedEditor.margin_left, -500, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
				tween.start()
		#associatedEditor.visible = false

func _pressed():
	emit_signal("on_press", buttonType)

func _process(dt):
	if tooltipRemainingTime > 0:
		tooltipRemainingTime -= dt
	else:
		tooltipRemainingTime = 0
		toFade = true
		
	if toFade:
		if tooltipRemainingFadeTime > 0:
			tooltipRemainingFadeTime -= dt
		else:
			tooltipRemainingFadeTime = 0
			toFade = false
			set_process(false)
			
	$tooltip.modulate.a = tooltipRemainingFadeTime / tooltipFadeTime

#if toggled:
#			self_modulate = Color(0.635, 0.635, 0.635, 1)
#			if tween and (tween is Tween):
#				tween.stop_all()
#				tween.interpolate_property(colorPlate, "margin_left", colorPlate.margin_left, -252, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
#				tween.start()
#		else:
#			self_modulate = Color(1, 1, 1, 1)
#			tween.stop_all()
#			tween.interpolate_property(colorPlate, "margin_left", colorPlate.margin_left, 198, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
#			tween.start()
