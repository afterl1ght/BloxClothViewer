extends CheckboxHitbox

# Checkbox for
# + Automatic lighting color based on solid color skybox (assuming light color is white)
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
	Preloader.worldenv.ambient_light_sky_contribution = 1
	print("ticked")
	._on_ticked()

func _on_unticked():
	Preloader.worldenv.ambient_light_sky_contribution = 0
	print("unticked")
	._on_unticked()
