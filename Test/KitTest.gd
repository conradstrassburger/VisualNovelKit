extends RakugoTest
class_name KitTest

var last_statement : String

func watch_custom_statments():
	Rakugo.sg_custom_regex.connect(_on_custom_regex)

func _on_custom_regex(key:String, _result:RegExMatch):
	last_statement = key

func wait_for_custom_statement(statement_id:String, max_wait: float):
	await wait_for_signal(Rakugo.sg_custom_regex, max_wait)
	assert_eq(last_statement, statement_id)
	last_statement = ""

func add_from_scene(path:String) -> Node:
	var scene = load(path)
	var node = scene.instantiate()
	get_tree().current_scene.add_child(node)
	return node

func assert_dialogue_panel(dialogue_panel: DialoguePanel):
	var nodes := [
		dialogue_panel,
		dialogue_panel.character_name_label,
		dialogue_panel.dialogue_label
	]
	for node in nodes:
		assert_not_null(node)

func assert_dialogue_panel_text(dialogue_panel: DialoguePanel, character_name, dialogue_text):
	assert_adv_text(dialogue_panel.character_name_label, character_name)
	assert_adv_text(dialogue_panel.dialogue_label, dialogue_text)

func wait_visblity(control: Control, visibility := true):
	await wait_for_signal(control.visibility_changed, 0.2)
	if visibility:
		assert_true(control.visible, control.name + " visibility")
	else:
		assert_false(control.visible, control.name + " visibility")

func assert_adv_text(adv_text: AdvancedTextLabel, text:String):
	assert_eq(adv_text._text, text)

