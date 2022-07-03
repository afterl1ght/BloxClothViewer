extends TextureButton

class_name EditorButtonBehavior
const BCVEditorButtons = Globals.BCVEditorButtons

signal on_press(button_type)

export(BCVEditorButtons) var buttonType
export(NodePath) var associatedEditorPath
onready var associatedEditor = get_node(associatedEditorPath)

func setEnable():
	self_modulate.a = 1
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
