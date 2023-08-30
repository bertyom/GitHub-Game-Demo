extends Label
onready var parent_node = $".."
var attribute_name = {
	"Strength": "STR",
	"Intelligence": "INT",
	"Agility": "AGI",
	"Charisma": "CHA"
}

func _ready():
	parent_node.connect("mouse_entered", self, "_on_mouse_entered")
	parent_node.connect("mouse_exited", self, "_on_mouse_exited")

func _on_mouse_entered():
	self.text = str(PlayerData.player_abilities[str(parent_node.name)])

func _on_mouse_exited():
	self.text = attribute_name[str(parent_node.name)]
