extends RKSExtension

func _group_name() -> StringName:
	return keys.show

const keys := {
	show = "show",
	hide = "hide",
	at_precise = "at precise",
	at_percent = "at percent",
	at_one = "at one",

}

const regex := {
	keys.show:
		"^show(( +\\w+)+)$",
	keys.hide:
		"^hide(( +\\w+)+)$",
	keys.at_precise:
		"^at +({NUMERIC}) +({NUMERIC})( +({NUMERIC}))?$",
	keys.at_percent:
		"^at% +({NUMERIC}) +({NUMERIC})$",
	keys.at_one:
		"^at ([xyz]) *=? *({NUMERIC})$",

}

func _ready():
	for key in keys:
		Rakugo.add_custom_regex(key, regex[key])

	super._ready()

var last_node : Node

func _on_custom_regex(key:String, result:RegExMatch):
	match key:
		keys.show:
			if result.get_group_count() == 0:
				push_error(err_mess_01 % [keys.show, group_name])
				return
			
			var nodes := rk_get_nodes(result.get_string(1))
			last_node = nodes.back()

			for node in nodes:
				for ch in node.get_children():
					try_call_method(ch, keys.hide)
				
				var err := err_mess_03 % [
					node.name, group_name, keys.show
				]
				try_call_method(node, keys.show, err)

		keys.hide:
			if result.get_group_count() == 0:
				push_error(err_mess_01 % [keys.hide, group_name])
				return

			var nodes := rk_get_nodes(result.get_string(1))
			for node in nodes:
				var err := err_mess_03 % [
					node.name, group_name, keys.hide
				]
				try_call_method(node, keys.hide, err)
		
		keys.at_precise:
			if !last_node:
				push_error(err_mess_04 % ["at", keys.show])
				return
			
			if result.get_group_count() == 0:
				# add error for to small numer of args ?
				return
			
			var x := float(result.get_string(1))
			var y := float(result.get_string(2))

			if result.get_string(4):
				var z := float(result.get_string(4))
				last_node.position = Vector3(x, y, z)
				return
			
				last_node.position = Vector2(x, y)
		
		keys.at_one:
			if !last_node:
				push_error(err_mess_04 % ["at", keys.show])
				return
			
			if result.get_group_count() == 0:
				# add error for to small numer of args ?
				return
			
			var axis := 




