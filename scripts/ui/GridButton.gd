extends TextureButton

export(NodePath) var uiMainPath
onready var uiMain : UIMain = get_node(uiMainPath)

var isPressed = false
var gridEnabled = true

var gridsquare : MeshInstance

func _ready():
	if gridEnabled:
		modulate.a = 1
	else:
		modulate.a = 0.25

func _pressed():
	gridEnabled = !gridEnabled
	
	if !uiMain:
		return
	else:
		if !gridsquare:
			if !uiMain.skinModel:
				return
			
			gridsquare = uiMain.skinModel.get_node("SkinMain/gridsquare")
			if !gridsquare:
				return
					
		
	gridsquare.visible = gridEnabled
	
	if gridEnabled:
		modulate.a = 1
	else:
		modulate.a = 0.25
