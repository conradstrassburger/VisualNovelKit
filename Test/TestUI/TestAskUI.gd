extends GUITest

const ask_panel_scene = "res://scenes/DialogueUI/ask_popup.tscn"
const file_path = "res://Test/TestUI/TestAsk.rk"

var file_base_name = get_file_base_name(file_path)

func assert_anwser_ui(line_edit: LineEdit, anwser:String):
	assert_true(Rakugo.is_waiting_ask_return())
	line_edit.text_submitted.emit(anwser)

func assert_anwser_placeholder(line_edit:LineEdit, placeholder:String):
	assert_eq(line_edit.placeholder_text, placeholder)

func test_ask():
	var ask_panel := add_panel_from_scene(ask_panel_scene)
	assert_dialogue_panel(ask_panel)
	watch_rakugo_signals()
	await wait_parse_and_execute_script(file_path)
	
	await wait_ask({"name": "Test"}, "Are you human ?", "Yes")
	assert_dialogue_panel_text(ask_panel, "# Test\n", "Are you human ?")
	assert_anwser_placeholder(ask_panel.line_edit, "Yes")
	assert_visblity(ask_panel) # passed
	assert_anwser_ui(ask_panel.line_edit, "No")
	# assert_visblity(ask_panel, false) # crashes

	await wait_ask({},"Your answer was No ?", "No")
	assert_dialogue_panel_text(ask_panel, "", "Your answer was No ?")
	assert_anwser_placeholder(ask_panel.line_edit, "No")
	# assert_visblity(ask_panel)
	assert_anwser_ui(ask_panel.line_edit, "Yes")
	# assert_visblity(ask_panel, false)
	
	await wait_execute_script_finished(file_base_name) 
