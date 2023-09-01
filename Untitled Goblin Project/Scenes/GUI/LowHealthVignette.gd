extends TextureRect
export(Curve) var vignette_map = null

func _ready():
	CommonFunctions.connect("player_stat_changed", self, "_on_Player_stat_changed")
	_on_Player_stat_changed("health", PlayerData.player_base_stats["health"], PlayerData.player_base_stats["max_health"])
	
func _on_Player_stat_changed(stat_name, stat_value, max_stat_value):
	if stat_name == "health":
		# Calculate the health ratio
		var health_ratio = float(stat_value) / max_stat_value
		# Get the alpha value from the curve
		var alpha = vignette_map.interpolate(health_ratio)
		# Convert the alpha value to a range usable by the 'modulate' property
		alpha = alpha/255.0
		# Set the modulate property, modifying only the alpha channel
		self.modulate = Color(1, 1, 1, alpha)
