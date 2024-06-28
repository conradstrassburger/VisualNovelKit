extends RakugoTest
class_name KitTest

func add_from_scene(path:String) -> Node:
	var scene = load(path)
	var node = scene.instantiate()
	get_tree().current_scene.add_child(node)
	return node

func assert_dialogue_panel(dialogue_panel: DialoguePanel):
	for node in [dialogue_panel, dialogue_panel.character_name_label, dialogue_panel.dialogue_label]:
		assert_not_null(node)

func assert_dialogue_panel_text(dialogue_panel: DialoguePanel, character_name, dialogue_text):
	assert_eq(dialogue_panel.character_name_label._text, character_name)
	assert_eq(dialogue_panel.dialogue_label._text, dialogue_text)

func wait_visblity(control: Control, visibility := true):
	await wait_for_signal(control.visibility_changed, 0.2)
	if visibility:
		assert_true(control.visible, control.name + " visibility")
	else:
		assert_false(control.visible, control.name + " visibility")

func wait_for_custom_statement(statement_id: String):
	await wait_for_signal(Rakugo.sg_custom_regex, 0.2)
	var params = get_signal_parameters(Rakugo, Rakugo.sg_custom_regex.get_name())
	assert_eq(params[0], statement_id)