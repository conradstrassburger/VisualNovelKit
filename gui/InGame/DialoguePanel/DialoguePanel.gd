extends PanelContainer
class_name DialoguePanel, "res://addons/Rakugo/icons/dialogue_panel.svg"

export var style = "default"

func _ready():
	Rakugo.connect("say", self, "_on_say")
	Rakugo.connect("ask", self, "_on_ask")

func _on_say(_character, _text, _parameters):

	if "style" in _parameters:
		if _parameters.style != style:
			hide()
			return

	show()

func _on_ask(_default_answer, _parameters):

	if "style" in _parameters:
		if _parameters.style != style:
			hide()
			return

	show()

func _step():
	hide()
