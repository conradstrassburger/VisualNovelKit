@tool
extends ProcentControl
class_name DialoguePanel

@export var character_name_label : AdvancedTextLabel
@export var dialogue_label : AdvancedTextLabel

func _ready():
	visibility_changed.connect(_on_visibility_changed)
	
	visible = Engine.is_editor_hint()
	set_process(false)

func set_labels(character:Dictionary, text:String):
	if !visible:
		show()
	
	var name_label = "[h1]{text}[/h1]" % character.get("name", "")
	var character_color = character.get("color", null)
	
	if character_color:
		name_label = "[color=%s]%s[/color]" % name_label
	
	character_name_label._text = name_label
	dialogue_label._text = text

func _on_visibility_changed():
	set_process(visible)