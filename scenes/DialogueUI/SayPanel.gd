extends DialoguePanel

func _ready():
	super._ready()
	Rakugo.sg_say.connect(set_labels)

func _process(_delta):
	if !Rakugo.is_waiting_step():
		hide()
		return

	if Input.is_action_just_pressed("interact"):
		Rakugo.do_step()
		hide()