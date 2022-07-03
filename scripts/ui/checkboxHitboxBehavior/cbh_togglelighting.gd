extends CheckboxHitbox

# Checkbox for enabling/disabling lighting
export(NodePath) var uimainpath
onready var uimain : UIMain = get_node(uimainpath)

var dlight : DirectionalLight
# environment file in preloader

func _process(dt):
	if uimain and !dlight:
		dlight = uimain.directionalLight
		if ticked:
			_on_ticked()
		else:
			_on_unticked()

func _on_ticked():
	if dlight:
		dlight.visible = false
	else:
		._on_unticked()
		return
	._on_ticked()

func _on_unticked():
	if dlight:
		dlight.visible = true
	else:
		._on_ticked()
		return
	._on_unticked()
