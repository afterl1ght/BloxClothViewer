extends ColorPlateCompat

func set_whole_sky_color(color : Color):
	Preloader.procsky.sky_top_color = selectedColor
	Preloader.procsky.ground_bottom_color = selectedColor
	Preloader.procsky.sky_horizon_color = selectedColor
	Preloader.procsky.ground_horizon_color = selectedColor
	#Preloader.worldenv.ambient_light_color = selectedColor

func do_post_ready():
	set_color_to_wheel(Preloader.procsky.sky_top_color)
	self.selectedColor = Preloader.procsky.sky_top_color

func set_color(val):
	.set_color(val)
	set_whole_sky_color(selectedColor)
