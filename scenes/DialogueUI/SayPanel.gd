@tool
extends DialoguePanel

## if true then it will be shown on `menu` staments
@export var keep_on_menu := true

@export var next_button : Button

func _ready():
	super._ready()
	Rakugo.sg_say.connect(set_labels)

	if keep_on_menu:
		Rakugo.sg_menu.connect(_on_menu)

func _on_say(character:Dictionary, text:String):
	next_button.show()
	set_labels(character, text)

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if keep_on_menu:
		if (not Rakugo.is_waiting_step()
		and not Rakugo.is_waiting_menu_return()):
			hide()
			return
	
	elif not Rakugo.is_waiting_step():
			hide()
			return
	
	if not keep_on_menu:
		if Input.is_action_just_pressed("interact"):
			Rakugo.do_step()
			hide()

func _on_menu(_choices:Array):
	next_button.hide()
	show()

func _on_next_btn_pressed():
	Rakugo.do_step()
	hide()
