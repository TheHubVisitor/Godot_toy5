extends Control

func _ready():
	hide()  # hidden by default

func show_popup():
	show()
	get_tree().paused = true

func _on_ok_pressed():
	hide()
	get_tree().paused = false
