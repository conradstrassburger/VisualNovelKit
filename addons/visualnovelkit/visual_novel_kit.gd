@tool
extends EditorPlugin
class_name VisualNovelKit

const setting_path = "application/addons/visual_novel_kit"
const default_markup_setting = setting_path + "/default_markup_setting"
const default_markup = "res://addons/visualnovelkit/default_markups/def_markdown.tres"

const rks_extesion_dir := "res://addons/visualnovelkit/rks_extensions"
const rks_show := "RKSShow"
const rks_show_ext := rks_extesion_dir + "/rks_show.gd"


func _enter_tree():

	ProjectSettings.set_setting(default_markup_setting, default_markup)

	# This dosen't work :(
	
	# var property_info = {
	# 	"name": default_markup_setting,
	# 	"type": TYPE_STRING,
	# 	"hint": PROPERTY_HINT_RESOURCE_TYPE,
	# }

	# ProjectSettings.add_property_info(property_info)

	add_autoload_singleton(rks_show, rks_show_ext)


func _exit_tree():
	ProjectSettings.set_setting(default_markup_setting, null)
	remove_autoload_singleton(rks_show)
