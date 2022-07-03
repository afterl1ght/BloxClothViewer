extends CheckboxHitbox

# Checkbox for enabling ambient lighting
# environment file in preloader

func _process(dt):
	if ticked:
		_on_ticked()
	else:
		_on_unticked()

func _on_ticked():
	Preloader.worldenv.ambient_light_sky_contribution = 1
	._on_ticked()

func _on_unticked():
	Preloader.worldenv.ambient_light_sky_contribution = 0
	._on_unticked()
