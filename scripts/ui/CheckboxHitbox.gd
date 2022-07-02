extends TextureButton

class_name CheckboxHitbox

export(bool) var ticked : bool = true
export(NodePath) var tickboxLocation

onready var tickbox : TextureRect = get_node(tickboxLocation)

func _ready():
	pressed = ticked

func _on_ticked():
	if tickbox:
		tickbox.texture = Preloader.checkboxYes
	
func _on_unticked():
	if tickbox:
		tickbox.texture = Preloader.checkboxNo

func _toggled(button_pressed):
	ticked = button_pressed
	if ticked:
		_on_ticked()
	else:
		_on_unticked()
