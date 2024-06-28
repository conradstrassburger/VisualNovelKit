extends RakugoTest
class_name GUITest

var timer : Timer

func add_from_scene(path:String) -> Node:
	var scene = load(path)
	var node = scene.instantiate()
	get_tree().current_scene.add_child(node)
	return node

func assert_dialogue_panel(dialogue_panel: DialoguePanel):
	assert_not_null(dialogue_panel)
	assert_not_null(dialogue_panel.character_name_label)
	assert_not_null(dialogue_panel.dialogue_label)

func assert_dialogue_panel_text(dialogue_panel: DialoguePanel, character_name, dialogue_text):
	assert_eq(dialogue_panel.character_name_label._text, character_name)
	assert_eq(dialogue_panel.dialogue_label._text, dialogue_text)

func wait_visblity(control: Control, visibility := true):
	await wait_for_signal(control.visibility_changed, 0.2)
	if visibility:
		assert_true(control.visible, control.name + " visibility")
	else:
		assert_false(control.visible, control.name + " visibility")
