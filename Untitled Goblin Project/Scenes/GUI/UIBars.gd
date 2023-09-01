extends Control

onready var health_bar = $V/HealthBar
onready var health_num = $V/HealthBar/Health
onready var glint_bar = $V/GlintBar
onready var glint_num = $V/GlintBar/Glint
onready var stamina_bar = $V/StaminaBar
onready var stamina_num = $V/StaminaBar/Stamina
onready var exp_bar = $V/ExpBar

func _ready():
	CommonFunctions.connect("player_stat_changed", self, "_on_Player_stat_changed")
	CommonFunctions.connect("player_exp_changed", self, "_on_Player_exp_changed")
	
	# Initialize the health, glint, stamina and exp bars based on current values in PlayerData
	health_bar.max_value = PlayerData.player_base_stats["max_health"]
	health_bar.value = PlayerData.player_base_stats["health"]
	health_num.text = str(PlayerData.player_base_stats["health"]) + "/" + str(PlayerData.player_base_stats["max_health"])

	glint_bar.max_value = PlayerData.player_base_stats["max_glint"]
	glint_bar.value = PlayerData.player_base_stats["glint"]
	glint_num.text = str(PlayerData.player_base_stats["glint"]) + "/" + str(PlayerData.player_base_stats["max_glint"])

	stamina_bar.max_value = PlayerData.player_base_stats["max_stamina"]
	stamina_bar.value = PlayerData.player_base_stats["stamina"]
	stamina_num.text = str(PlayerData.player_base_stats["stamina"]) + "/" + str(PlayerData.player_base_stats["max_stamina"])

	exp_bar.max_value = PlayerData.player_exp["next_lvl_exp"]
	exp_bar.value = PlayerData.player_exp["exp"]

func _on_Player_stat_changed(stat_name, stat_value, max_stat_value):
	match stat_name:
		"health":
			health_bar.value = stat_value
			health_num.text = str(stat_value) + "/" + str(max_stat_value)
		"glint":
			glint_bar.value = stat_value
			glint_num.text = str(stat_value) + "/" + str(max_stat_value)
		"stamina":
			stamina_bar.value = stat_value
			stamina_num.text = str(stat_value) + "/" + str(max_stat_value)

func _on_Player_exp_changed(exp_name, exp_value):
	match exp_name:
		"exp":
			exp_bar.value = exp_value
		"next_lvl_exp":
			exp_bar.max_value = exp_value
