extends Control

func _ready():
	$VBoxContainer/Easy.pressed.connect(_on_easy_pressed)
	$VBoxContainer/Hard.pressed.connect(_on_hard_pressed)
	$VBoxContainer/Expert.pressed.connect(_on_expert_pressed)
	$VBoxContainer/ForgetIt.pressed.connect(_on_forget_it_pressed)

func _on_easy_pressed():
	settings.set_mode("easy")
	start_game()

func _on_hard_pressed():
	settings.set_mode("hard")
	start_game()

func _on_expert_pressed():
	settings.set_mode("expert")
	start_game()

func _on_forget_it_pressed():
	settings.set_mode("forget_it")
	start_game()

func start_game():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
