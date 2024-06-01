@tool
extends Node
class_name VisualNovelKit

const setting_path = "application/addons/visual_novel_kit"
const default_markup_setting_path = setting_path + "/default_markup_setting"
const default_markup = "res://addons/visualnovelkit/default_markups/def_markdown.tres"

const rks_extesion_dir := "res://addons/visualnovelkit/rks_extensions"
const rks_extesions := {
	RKSShow = rks_extesion_dir + "/rks_show.gd",
}

static  var default_markup_setting: String:
	set (value):
		ProjectSettings.set_setting(default_markup_setting_path, value)
	get:
		return ProjectSettings.get_setting(default_markup_setting_path)