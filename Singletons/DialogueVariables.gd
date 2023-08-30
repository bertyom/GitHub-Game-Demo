extends Node

func hex_to_color(hex):
	var c = Color(hex)
	return Color8(c.r8, c.g8, c.b8, 255)

var speaker_colors = {
	"You": hex_to_color("#ffe055"),
	# Add more speakers here...
}

var has_read_test1 = false
