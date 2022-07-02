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
		associatedEditor.visible = true

func setDisable():
	self_modulate.a = 0.25
	if associatedEditor:
		associatedEditor.visible = false

func _pressed():
	emit_signal("on_press", buttonType)
