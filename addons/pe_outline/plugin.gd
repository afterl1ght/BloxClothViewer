tool
extends EditorPlugin

"""
	Post Effect Outline Shader for Godot Engine by Yui Kinomoto @arlez80
"""

func _enter_tree( ):
	self.add_custom_type( "PostEffectOutlineBox", "MeshInstance", preload("PostEffectOutline.gd"), preload("icon.png") )

func _exit_tree( ):
	self.remove_custom_type( "PostEffectOutlineBox" )

func get_plugin_name( ):
	return "Post Effect Outline Shader"
