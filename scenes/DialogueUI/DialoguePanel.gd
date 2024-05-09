@tool
extends ProcentControl
class_name DialoguePanel

const setting_path = "application/addons/visual_novel_kit"
const default_markup_setting = setting_path + "/default_markup_setting"

@export var character_name_label : AdvancedTextLabel
@export var dialogue_label : AdvancedTextLabel

var markup : TextParser

func _ready():
	markup = load(ProjectSettings.get_setting(default_markup_setting))
	character_name_label.parser = markup
	dialogue_label.parser = markup

	visibility_changed.connect(_on_visibility_changed)
	
	visible = Engine.is_editor_hint()
	set_process(false)

func set_labels(character:Dictionary, text:String):
	if !visible:
		show()
	
	var character_name = character.get("name", "")
	var name_label = "[h1]%s[/h1]" % character_name

	if markup is MarkdownParser:
		name_label = "# %s\n" % character_name

	var character_color = character.get("color", null)
	
	if character_color:
		name_label = "[color=%s]%s[/color]" % name_label
	
	character_name_label._text = name_label
	dialogue_label._text = text

func _on_visibility_changed():
	set_process(visible)