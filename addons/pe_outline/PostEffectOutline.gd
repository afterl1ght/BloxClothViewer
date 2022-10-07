tool
extends MeshInstance

class_name PostEffectOutlineBox

#
# ポストエフェクト箱設定 と ドームの動的移動 by あるる（きのもと 結衣） @arlez80
#

export(Color) var outline_color:Color = Color(0.0,0.0,0.0,1.0) setget set_outline_color

export(float) var luma_coef:float = 80.0 setget set_luma_coef
export(float) var color_coef:float = 80.0 setget set_color_coef
export(float) var depth_coef:float = 8.0 setget set_depth_coef
export(float) var cutoff:float = 0.1 setget set_cutoff

export(bool) var auto_follow_camera:bool = true

var shader:ShaderMaterial = null
var needs_update:bool = false

func _ready( ):
	var cm:CubeMesh = CubeMesh.new( )
	cm.size = Vector3.ONE
	cm.flip_faces = true
	self.mesh = cm

	var sm:ShaderMaterial = ShaderMaterial.new( )
	sm.shader = preload("sobel_outline.shader")
	sm.render_priority = 127
	self.material_override = sm
	self.shader = sm

func _process( delta:float ):
	if self.needs_update:
		self._update_shader_param( )
	self._move_to_camera( )

func _move_to_camera( ):
	if not self.auto_follow_camera:
		return

	var camera:Camera = self.get_viewport( ).get_camera( )
	if camera == null:
		return

	var middle:float = ( camera.far + camera.near ) / 2.0

	self.global_transform.origin = camera.global_transform.origin
	self.transform.basis.x = Vector3( middle, 0.0, 0.0 )
	self.transform.basis.y = Vector3( 0.0, middle, 0.0 )
	self.transform.basis.z = Vector3( 0.0, 0.0, middle )

func _update_shader_param( ):
	self.shader.set_shader_param( "outline_color", self.outline_color )
	self.shader.set_shader_param( "luma_coef", self.luma_coef )
	self.shader.set_shader_param( "color_coef", self.color_coef )
	self.shader.set_shader_param( "depth_coef", self.depth_coef )
	self.shader.set_shader_param( "cutoff", self.cutoff )

func set_outline_color( _outline_color:Color ):
	outline_color = _outline_color
	self._update_shader_param( )

func set_luma_coef( _luma_coef:float ):
	luma_coef = _luma_coef
	self._update_shader_param( )

func set_color_coef( _color_coef:float ):
	color_coef = _color_coef
	self._update_shader_param( )

func set_depth_coef( _depth_coef:float ):
	depth_coef = _depth_coef
	self._update_shader_param( )

func set_cutoff( _cutoff:float ):
	cutoff = _cutoff
	self._update_shader_param( )
