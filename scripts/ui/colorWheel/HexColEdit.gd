extends LineEdit

class_name HexColEdit

export(NodePath) var uiMainPath
onready var uiMain : UIMain = get_node(uiMainPath)

var parent : ColorPlate

var hexlen : int = 6
var previous : String = "FFFFFF"

var text_changing = false

var afterready = false
var prevent_enable_input = false

var is_focused = false

func _ready():
	focus_mode = FOCUS_NONE
	parent = get_parent()
	
	connect("text_changed", self, "text_changed")
	
	# why didn't i use this earlier
	connect("focus_entered", self, "focus_entered")
	connect("focus_exited", self, "focus_exited")
	
	if parent:
		parent.connect("on_color_changed", self, "sync_color")

func is_valid(txt : String):
	if txt.length() > hexlen:
		return false
	elif txt.length() <= 0:
		return true
	
	return txt.is_valid_hex_number(false)
	
func fill_blank(txt : String) -> String:
	var diff = hexlen - txt.length()
	if diff > 0:
		var filler = ""
		for _i in diff:
			filler += "f"
		return txt + filler
		
	return txt

func sync_color(col : Color):
	if !text_changing or !afterready:
		text = col.to_html(false)
		previous = text
		if !afterready:
			afterready = true
			focus_mode = FOCUS_CLICK

func isWithinRect(pos, tolerance = 1):
	return (rect_global_position.x < pos.x) and (rect_global_position.y < pos.y) and (rect_global_position.x + rect_size.x > pos.x) and (rect_global_position.y + rect_size.y > pos.y)

var enable_input_check = false

func _unhandled_input(event):
	if enable_input_check:
		if event and (event is InputEventScreenTouch and event.pressed) or event is InputEventScreenDrag:
			# Out of focus, correct text
			release_focus()
			selecting_enabled = false
			enable_input_check = false
			if !is_valid(text):
				text = previous
			
			text = fill_blank(text)
			
func _input(event):
	if !afterready:
		return
	
	if event and event is InputEventScreenDrag:
		prevent_enable_input = true
	else:
		prevent_enable_input = false
	
	if event and event is InputEventScreenTouch and event.pressed:
		if !isWithinRect(event.position) and enable_input_check:
			release_focus()
			selecting_enabled = false
			enable_input_check = false
			if !is_valid(text):
				text = previous
				
			text = fill_blank(text)
		else:
			if !prevent_enable_input:
				enable_input_check = true
				selecting_enabled = true

func focus_entered():
	is_focused = true

func focus_exited():
	is_focused = false

func text_changed(newtext):
	text_changing = true
	if !is_valid(newtext):
		editable = false
		var curpos = caret_position-1
		text = previous
		if OS.has_virtual_keyboard():
			OS.show_virtual_keyboard(text)
		caret_position = max(0, min(curpos, text.length()))
		
		editable = true
		previous = text
	else:
		previous = newtext
	
	var designatedColor : Color = Color(fill_blank(text))
	parent.set_color_to_wheel(designatedColor)
	parent.selectedColor = designatedColor
	
	print(text)
	text_changing = false
	
func _process(_delta):
	if !afterready:
		return
	
	# TODO: Change height position when virtual keyboard (non-floating state) exceeds the plate's height
	if uiMain:
		if is_focused: # Basically if the text field is focused
			uiMain.focusing_text_field = self
		else:
			uiMain.focusing_text_field = null
