extends RakugoTest

const say_panel_scene = "res://scenes/DialogueUI/say_panel.tscn"
const file_path = "res://Test/TestUI/TestSay.rk"


var file_base_name = get_file_base_name(file_path)

func test_say_ui():
	var scene = load(say_panel_scene)
	var say_panel := scene.instantiate() as DialoguePanel
	assert_not_null(say_panel)
	assert_not_null(say_panel.character_name_label)
	assert_not_null(say_panel.dialogue_label)
	
	watch_rakugo_signals()
	await wait_parse_and_execute_script(file_path)

	await wait_say({}, "Hello, world !")
	await say_panel.visibility_changed
	assert_true(say_panel.visible)
	assert_eq(say_panel.character_name_label._text, "")
	assert_eq(say_panel.dialogue_label._text, "Hello, world !")

	assert_do_step()
	await say_panel.visibility_changed
	assert_false(say_panel.visible)
	
	await wait_say({"name": "Sylvie"}, "Hello !")
	await say_panel.visibility_changed
	assert_true(say_panel.visible)
	assert_eq(say_panel.character_name_label._text, "Sylvie")
	assert_eq(say_panel.dialogue_label._text, "Hello !")

	assert_do_step()
	await say_panel.visibility_changed
	assert_false(say_panel.visible)

	await wait_say({}, "My name is Sylvie")
	await say_panel.visibility_changed
	assert_true(say_panel.visible)
	assert_eq(say_panel.character_name_label._text, "")
	assert_eq(say_panel.dialogue_label._text, "My name is Sylvie")
	
	assert_do_step()
	await say_panel.visibility_changed
	assert_false(say_panel.visible)
	
	await wait_say({}, "I am 18")
	await say_panel.visibility_changed
	assert_true(say_panel.visible)
	assert_eq(say_panel.character_name_label._text, "")
	assert_eq(say_panel.dialogue_label._text, "I am 18")
	
	assert_do_step()
	await say_panel.visibility_changed
	assert_false(say_panel.visible)

	await wait_execute_script_finished(file_base_name)


