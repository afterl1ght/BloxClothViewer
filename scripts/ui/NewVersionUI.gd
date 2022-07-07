extends TextureRect

export(NodePath) var updateUIPath
var updateUI : UpdateUI

export(String) var newReleaseLink = "https://github.com/afterl1ght/BloxClothViewer/releases"

var initial_rect_pos = Vector2.ZERO

# default value that will be changed later
var base_width = 720
var base_heght = 1080

# Button effect
var yesPressTime = 0
var noPressTime = 0
var maxPressTimeEach = 0.25

func _ready():
	initial_rect_pos = rect_position
	updateUI = get_node(updateUIPath)
	
	var bw = ProjectSettings.get_setting("display/window/size/width")
	var bh = ProjectSettings.get_setting("display/window/size/height")
	if bw:
		base_width = bw
	if bh:
		base_heght = bh
	
	$Yes.connect("pressed", self, "yesFunc")
	$No.connect("pressed", self, "noFunc")

func _process(dt):
	if yesPressTime > 0:
		yesPressTime -= dt
		$Yes.rect_scale = Vector2(0.75, 0.75)
	else:
		yesPressTime = 0
		$Yes.rect_scale = Vector2(1, 1)
		
	if noPressTime > 0:
		noPressTime -= dt
		$No.rect_scale = Vector2(0.75, 0.75)
	else:
		noPressTime = 0
		$No.rect_scale = Vector2(1, 1)

func yesFunc():
	if yesPressTime > 0:
		return
	
	yesPressTime = maxPressTimeEach
	OS.shell_open(newReleaseLink)

func noFunc():
	if noPressTime > 0:
		return
	
	noPressTime = maxPressTimeEach
	if !updateUI:
		return
	
	$Tween.stop_all()
	$Tween.interpolate_method(self, "update_appearance", 0, 1, 0.75, 4, 0)
	$Tween.start()
	if updateUI.overlay:
		updateUI.overlay.deactivate()

func update_appearance(v):
	rect_position.y = v * (1440 * get_viewport().size.y / base_width) + (1-v) * (get_viewport().size.y/2 - rect_size.y/4)
	if v != 1 and v != -1:
		visible = true
	else:
		visible = false
