@tool
extends EditorPlugin

const setting_path = "application/addons/visual_novel_kit"
const default_markup_setting = setting_path + "/default_markup_setting"
const default_markup = "res://addons/visualnovelkit/default_markups/def_markdown.tres"

func _enter_tree():

	var property_info = {
		"name": default_markup_setting,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
	}

	ProjectSettings.set_setting(default_markup_setting, default_markup)
	ProjectSettings.add_property_info(property_info)


func _exit_tree():
	ProjectSettings.set_setting(default_markup_setting, null)
