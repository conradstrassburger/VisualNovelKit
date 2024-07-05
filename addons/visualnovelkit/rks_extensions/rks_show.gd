extends RKSExtension

func _group_name() -> StringName:
	return Show

const Show := "show"
const Hide := "hide"
const AtPrecise = "at precise"
const AtPercent = "at percent"
const AtOne = "at one"
const AtPredef = "at predef"

const regex := {
	Show:
		"^show(( +\\w+)+)$",
	Hide:
		"^hide(( +\\w+)+)$",
	AtPrecise:
		"^at +({NUMERIC}) +({NUMERIC})( +({NUMERIC}))?$",
	AtPercent:
		"^at% +({NUMERIC}) +({NUMERIC})$",
	AtOne:
		"^at +([xyz]) *([-+\\*\\/])?=? *({NUMERIC})$",
	AtPredef:
		"^at +(\\w+)$",
}

@onready
var at_predefs := {
	# center
	"center" : VisualNovelKit.at_center,
	"left" : Vector2(VisualNovelKit.at_left, VisualNovelKit.at_center.y),
	"right" :  Vector2(VisualNovelKit.at_right, VisualNovelKit.at_center.y),

	# top
	"top" : Vector2(VisualNovelKit.at_center.x, VisualNovelKit.at_top),
	"top_left" : Vector2(VisualNovelKit.at_left, VisualNovelKit.at_top),
	"top_right" : Vector2(VisualNovelKit.at_right, VisualNovelKit.at_top),
	
	# bottom
	"bottom_center" : Vector2(VisualNovelKit.at_center.x, VisualNovelKit.at_bottom),
	"bottom_left" : Vector2(VisualNovelKit.at_left, VisualNovelKit.at_bottom),
	"bottom_right" : Vector2(VisualNovelKit.at_right, VisualNovelKit.at_bottom),
} 

func _ready():
	for key in regex:
		Rakugo.add_custom_regex(key, regex[key])

	super._ready()

var last_node : Node

func _on_custom_regex(key:String, result:RegExMatch):
	match key:
		Show:
			if result.get_group_count() == 0:
				push_error(err_mess_01 % [Show, group_name])
				return
			
			var nodes := rk_get_nodes(result.get_string(1))
			last_node = nodes[0]

			for node in nodes:
				for ch in node.get_children():
					try_call_method(ch, Hide)
				
				var err := err_mess_03 % [
					node.name, group_name, Show
				]
				try_call_method(node, Show, err)

		Hide:
			if result.get_group_count() == 0:
				push_error(err_mess_01 % [Hide, group_name])
				return

			var nodes := rk_get_nodes(result.get_string(1))
			for node in nodes:
				var err := err_mess_03 % [
					node.name, group_name, Hide
				]
				try_call_method(node, Hide, err)
		
		AtPrecise:
			if !last_node:
				push_error(err_mess_04 % ["at", Show])
				return
			
			if result.get_group_count() == 0:
				# add error for to small numer of args ?
				push_error("error: " + result.get_string(0))
				return
			
			var x := float(result.get_string(1))
			var y := float(result.get_string(2))

			if result.get_string(4):
				var z := float(result.get_string(4))
				last_node.position = Vector3(x, y, z)
				return
			
			last_node.position = Vector2(x, y)
		
		AtOne:
			if !last_node:
				push_error(err_mess_04 % ["at", Show])
				return
			
			if result.get_group_count() == 0:
				# add error for to small numer of args ?
				return
			
			var axis := result.get_string(1)
			var value := float(result.get_string(2))
			match axis:
				"x":
					last_node.position.x = value
				"y":
					last_node.position.y = value
				"z":
					last_node.position.z = value
			
		AtPercent:
			var procent := Vector2()
			procent.x = float(result.get_string(1))/100
			procent.y = float(result.get_string(2))/100
			var vp_size := get_viewport().get_visible_rect().size
			last_node.position = procent * vp_size
		
		AtPredef:
			var predef := result.get_string(1)
			var procent : Vector2 = at_predefs[predef]
			var vp_size := get_viewport().get_visible_rect().size
			last_node.position = procent * vp_size





