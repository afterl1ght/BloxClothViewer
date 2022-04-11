extends TextureButton

class_name SmolButts

export(int) var bodyIndex = 0
onready var parent : AvtSubButtons = get_parent()

func _pressed():
	if parent:
		if parent.selectedIndex == bodyIndex:
			parent.selectedIndex = -1
		else:
			parent.selectedIndex = bodyIndex
			
func _process(_dt):
	if parent.selectedIndex == bodyIndex:
		$SelectCircle.visible = true
	else:
		$SelectCircle.visible = false
