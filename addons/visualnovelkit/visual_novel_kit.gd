@tool
extends EditorPlugin


func _enter_tree():
	VisualNovelKit.default_markup_setting = VisualNovelKit.default_markup
	for ext in VisualNovelKit.rks_extesions:
		var ext_script : String = VisualNovelKit.rks_extesions[ext]
		add_autoload_singleton(ext, ext_script)

func _exit_tree():
	VisualNovelKit.default_markup_setting = str(null)
	for ext in VisualNovelKit.rks_extesions:
		remove_autoload_singleton(ext)
