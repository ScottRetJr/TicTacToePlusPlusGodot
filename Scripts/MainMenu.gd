extends Control

#Author: Scott Retford Jr
#Last Edit: 10/29/2020

#The functions below are all assigned to various buttons within the main menu.
#The two "Opponent" functions set a singleton variable that governs certain
#actions in the Game.gd script, and then load the game. The "Instruction" and
#"Back" button functions just show and hide an quick intro message.
func _on_CPUOpponentButton_pressed():
	Singleton.singlePlayer = true
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_HumanOpponentButton_pressed():
	Singleton.singlePlayer = false
	get_tree().change_scene("res://Scenes/Game.tscn")

#For those unfamiliar with Godot and GDScript: anything prefixed with a '$' 
#symbol is accessing a node in the scene tree. I usually place and format these 
#within the built-in GUI editor, while controling them with scripts such as
#below.
func _on_InstructionsButton_pressed():
	$Label.visible = false
	$CPUOpponentButton.visible = false
	$HumanOpponentButton.visible = false
	$InstructionsButton.visible = false
	
	$InstructionPanel.visible = true

func _on_BackButton_pressed():
	$Label.visible = true
	$CPUOpponentButton.visible = true
	$HumanOpponentButton.visible = true
	$InstructionsButton.visible = true
	
	$InstructionPanel.visible = false
