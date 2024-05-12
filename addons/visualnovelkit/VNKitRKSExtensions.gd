extends Node
# VNKitRKSExtensions

const show_group_name := "show"
const err_mess_01 := "%s stament is missing any node name from `%s` group"
const err_mess_02 := "%s node in `%s` group dosen't have any funcs called: %s"


var show_group := {}

func _ready():
	Rakugo.add_custom_regex("show", "^show(( +\\w+)+)$")
	Rakugo.add_custom_regex("hide", "^hide(( +\\w+)+)$")

	Rakugo.sg_custom_regex.connect(_on_custom_regex)

	get_tree().node_added.connect(node_added)
	get_tree().node_removed.connect(node_removed)
	update_group(show_group_name, show_group, ["show", "hide"])
	prints("show group:", show_group)

func node_added(node:Node):
	if node.is_in_group(show_group_name):
		var node_id := node.name.to_snake_case()
		add_node_to_group(show_group_name, show_group, node, ["show", "hide"])

func has_methods(node:Node, methods:Array[String]) -> bool:
	var result := 0
	for method in methods:
		if node.has_method(method):
			result += 1

	return result == methods.size()

func init_group_node(group_dict:Dictionary, node:Node) -> String:
	var node_id := node.name.to_snake_case()
	group_dict[node_id] = {"_node": node}
	return node_id

func add_node_to_group(group_name:String, group_dict:Dictionary, node:Node, methods:Array[String], error := true) -> bool:
	var node_id := init_group_node(group_dict, node)
	if has_methods(node, methods):
		if node.get_child_count() > 0:
			for ch in node.get_children():
				add_node_to_group(group_name, group_dict[node_id], ch, methods, false)
		
		return true
	
	if error:
		push_error(err_mess_02 % [node_id, group_name, str(methods)])
	
	group_dict.erase(node_id)
	return false

func node_removed(node: Node):
	if node.is_in_group(show_group_name):
		var node_id := node.name.to_snake_case()
		if show_group.has(node_id):
			show_group.erase(node_id)

func update_group(group_name:String, group_dict:Dictionary, methods: Array[String]):
	var nodes := get_tree().get_nodes_in_group(group_name)
	for node in nodes:
		var node_id := init_group_node(group_dict, node)
		if !add_node_to_group(group_name, group_dict, node, methods):
			if group_dict.has(node_id):
				group_dict.erase(node_id)

func call_on_node_in_group(node_id: String, group_dict: Dictionary, method: String, args:=[]):
	if args.size() > 0:
		group_dict[node_id]._node.callv(method, args)
	else:
		group_dict[node_id]._node.call(method)

func call_on_nodes_in_group(nodes: Array, group_dict: Dictionary, method: String):
	if nodes.size() >= 1:
		var node_id = nodes.pop_front()
		call_on_node_in_group(node_id, group_dict, method)
		
		if nodes.size() > 0:
			call_on_nodes_in_group(nodes, group_dict[node_id], method)

# func call_on_last_node(nodes: Array, group_dict: Dictionary, method: String, args:=[]):
# 	if nodes == 0:

# 	var node
# 	var node_id
# 	while nodes.size() > 1:
# 		node_id = nodes.pop_front()
# 		group_dict = group_dict[node_id]
# 		print(group_dict)

# 		call_on_node_in_group(node_id, group_dict, method, args)

func _on_custom_regex(key:String, result:RegExMatch):
	match key:
		"show":
			if result.get_group_count() == 0:
				push_error(err_mess_01 % ["show", show_group_name])
				return

			var g1 := result.get_string(1)
			var nodes := Array(g1.split(" ", false))

			call_on_nodes_in_group(nodes, show_group, "show")
		
		# "hide":
		# 	if result.get_group_count() == 0:
		# 		push_error(err_mess_01 % ["hide", show_group_name])
		# 		return

		# 	var g1 := result.get_string(1)
		# 	var nodes := Array(g1.split(" ", false))

		# 	call_on_last_node(nodes, show_group, "hide")
