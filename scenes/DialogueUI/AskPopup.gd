extends DialoguePanel

@export var line_edit : LineEdit

func _ready():
	super._ready()
	Rakugo.sg_ask.connect(_on_ask)

func _on_ask(character:Dictionary, question:String, default_answer:String):
	set_labels(character, question)
	line_edit.placeholder_text = default_answer

func _process(_delta):
	if Rakugo.is_waiting_ask_return():
		hide()
		return

	if Input.is_action_just_pressed("interact"):
		if !line_edit.text:
			Rakugo.ask_return(line_edit.placeholder_text)
		else:
			Rakugo.ask_return(line_edit.text)

		hide()

func _on_default_answer_btn_pressed():
	Rakugo.ask_return(line_edit.placeholder_text)
	hide()

func _on_ok_btn_pressed():
	Rakugo.ask_return(line_edit.text)
	hide()
