extends ColorPlateCompat

func set_fake_sky_color(color : Color):
	Preloader.fakeskymat.set_shader_param("albedo", color)

func set_whole_sky_color(color : Color):
	Preloader.procsky.sky_top_color = color
	Preloader.procsky.ground_bottom_color = color
	Preloader.procsky.sky_horizon_color = color
	Preloader.procsky.ground_horizon_color = color
	#Preloader.worldenv.ambient_light_color = selectedColor

func do_post_ready():
	set_color_to_wheel(Preloader.procsky.sky_top_color)
	self.selectedColor = Preloader.procsky.sky_top_color

func tapped():
	set_whole_sky_color(selectedColor)

func drag_started():
	set_fake_sky_color(selectedColor)

func drag_released():
	set_whole_sky_color(selectedColor)

func hue_tapped():
	tapped()
	
func value_tapped():
	tapped()

func hue_drag_started():
	drag_started()
	
func hue_drag_released():
	drag_released()
	
func value_drag_started():
	drag_started()
	
func value_drag_released():
	drag_released()

func set_color(val):
	.set_color(val)
	set_fake_sky_color(selectedColor)
