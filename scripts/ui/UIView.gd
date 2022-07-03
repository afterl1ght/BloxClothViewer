extends Control

class_name UIMain

export(NodePath) var skinModelPath
onready var skinModel : SkinModel = get_node(skinModelPath)

export(NodePath) var directionalLightPath
onready var directionalLight : DirectionalLight = get_node(directionalLightPath)

# UI y position
var ui_y_height = 0
# UI offset (i.e. for text field visibility when a virtual keyboard pops up)
var ui_height_offset = 0

# For automatic adjust when virtual keyboard shows up
var is_focused = false
var focusing_text_field : Control = null
var focused_global_pos : Vector2 = Vector2.ZERO
var focus_unsafe_offset = 12 # pixels

func get_focus_y_bottom():
	if focusing_text_field:
		return focused_global_pos.y + focusing_text_field.rect_size.y * focusing_text_field.rect_scale.y
	return 0

func _process(delta):
	var virtkeybh = OS.get_virtual_keyboard_height()
	if focusing_text_field != null and virtkeybh > 0:
		if !is_focused:
			is_focused = true
			# Set original global position before change so the global pos won't be changed while UIMain is moved
			# TODO: record possible strange stuf that may occur using this approach
			focused_global_pos = focusing_text_field.rect_global_position
		
		var y_bottom = get_focus_y_bottom() + focus_unsafe_offset
		var y_keyboard = max(0, get_viewport().size.y - virtkeybh)
		
		if y_bottom > y_keyboard:
			ui_height_offset = y_keyboard - y_bottom
	else:
		if focusing_text_field == null and virtkeybh > 0:
			# Text fields that are focused should be assigned to this variable, else the keyboard might not show up because of this condition
			OS.hide_virtual_keyboard()
			
		ui_height_offset = 0
		is_focused = false
		focused_global_pos = Vector2.ZERO
		
	rect_position = Vector2(rect_position.x, ui_y_height + ui_height_offset)
