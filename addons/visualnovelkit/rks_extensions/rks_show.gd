extends RKSExtension

func _group_name() -> StringName:
	return &"show"

func _ready():
	Rakugo.add_custom_regex("show", "^show(( +\\w+)+)$")
	Rakugo.add_custom_regex("hide", "^hide(( +\\w+)+)$")
	Rakugo.add_custom_regex("at", "^at((( +\\d+(\\.\\d+)?)+){2,3})$")

	super._ready()

var last_node : Node

func _on_custom_regex(key:String, result:RegExMatch):
	match key:
		"show":
			if result.get_group_count() == 0:
				push_error(err_mess_01 % ["show", group_name])
				return
			
			var nodes := rk_get_nodes(result.get_string(1))
			last_node = nodes.back()
			for node in nodes:
				for ch in node.get_children():
					try_call_method(ch, "hide")
				
				var err := err_mess_03 % [
					node.name, group_name, "show"
				]
				try_call_method(node, "show", err)

		"hide":
			if result.get_group_count() == 0:
				push_error(err_mess_01 % ["hide", group_name])
				return

			var nodes := rk_get_nodes(result.get_string(1))
			for node in nodes:
				var err := err_mess_03 % [
					node.name, group_name, "hide"
				]
				try_call_method(node, "hide", err)
		
		"at":
			if !last_node:
				push_error(err_mess_04 % ["at", "show"])
				return
			
				var str_vec := result.get_string(1)
				var vec_arr := str_vec.split(" ", false)

				if vec_arr.size() == 2:
					last_node.position = Vector2(int(vec_arr[0]), int(vec_arr[1]))
				
				elif vec_arr.size() == 3:
					last_node.position = Vector3(int(vec_arr[0]), int(vec_arr[1]), int(vec_arr[2]))

