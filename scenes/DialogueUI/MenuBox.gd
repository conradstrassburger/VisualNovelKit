extends VBoxContainer

@export var parent: Control

var markup : TextParser

func _ready():
	if Engine.is_editor_hint():
		return
	
	markup = load(
		ProjectSettings.get_setting(
			VisualNovelKit.default_markup_setting
		)
	)
	Rakugo.sg_menu.connect(_on_menu)
	
	if parent:
		visibility_changed.connect(_on_visibility_changed)
	
	hide()

func _on_visibility_changed():
	parent.visible = visible

func _on_menu(choices:Array):
	for ch in get_children():
		ch.queue_free()

	for id in range(choices.size()):
		var choice_btn := AdvancedTextButton.new()
		add_child(choice_btn)
		choice_btn.fit_content = true
		choice_btn.scroll_active = false
		choice_btn.shortcut_keys_enabled = false
		choice_btn.parser = markup
		choice_btn._text = choices[id]
		choice_btn.pressed.connect(_on_choice.bind(id))

	show()

func _on_choice(id: int):
	Rakugo.menu_return(id)
	hide()
