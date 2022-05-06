extends TextureRect

# HexColPreviewSync... I must've been really sleepy while naming this
class_name HexColPlate

var parent : ColorPlate

func _ready():
	parent = get_parent()
	
	if parent:
		parent.connect("on_color_changed", self, "on_color_changed")
		
func on_color_changed(col):
	$SquareUnderneath.self_modulate = col
