extends RakugoTest
class_name GUITest

var timer : Timer

func add_panel_from_scene(path:String) -> DialoguePanel:
	var scene = load(path)
	var panel := scene.instantiate() as DialoguePanel
	get_tree().current_scene.add_child(panel)
	return panel

func assert_dialogue_panel(dialogue_panel: DialoguePanel):
	assert_not_null(dialogue_panel)
	assert_not_null(dialogue_panel.character_name_label)
	assert_not_null(dialogue_panel.dialogue_label)

func assert_dialogue_panel_text(dialogue_panel: DialoguePanel, character_name, dialogue_text):
	assert_eq(dialogue_panel.character_name_label._text, character_name)
	assert_eq(dialogue_panel.dialogue_label._text, dialogue_text)

func assert_visblity(control: Control, visibility := true):
	await wait_for_signal(control.visibility_changed, 0.2)
	if visibility:
		assert_true(control.visible)
	else:
		assert_false(control.visible)
