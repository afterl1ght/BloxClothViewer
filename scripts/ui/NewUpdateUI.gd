extends TextureButton

var initial_rect_pos = Vector2.ZERO
func _ready():
	initial_rect_pos = rect_position

func update_appearance(v):
	if v <= 0:
		visible = false
		mouse_filter = MOUSE_FILTER_IGNORE
	else:
		visible = true
		mouse_filter = MOUSE_FILTER_STOP
	modulate.a = v
	rect_scale = Vector2(v, v)

var time = 0
func _process(dt):
	if !visible:
		return
		
	time += dt
	rect_rotation = sin(time * 1.6) * 5
	rect_position.y= initial_rect_pos.y + sin(time * 1.25) * 5

func _pressed():
	if (get_parent()):
		get_parent().on_new_update_tap()
		get_parent().new_update_notif_time = 0
		get_parent().new_update_notif_appear = false
