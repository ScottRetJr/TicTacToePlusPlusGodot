extends Node2D

#Preloading token textures for easy access below.
const RED = preload("res://Assets/Red.png")
const BLACK = preload("res://Assets/Black.png")

#Virtual board in memory to keep track of token positions. Simple 7x7 2D array.
var board = [[0, 0, 0, 0, 0, 0, 0],
			 [0, 0, 0, 0, 0, 0, 0],
			 [0, 0, 0, 0, 0, 0, 0],
			 [0, 0, 0, 0, 0, 0, 0],
			 [0, 0, 0, 0, 0, 0, 0],
			 [0, 0, 0, 0, 0, 0, 0],
			 [0, 0, 0, 0, 0, 0, 0]]
var emptyTile: int = 0
var redTile: int = 1
var blackTile: int = 2

#Keeping track of whose turn it is. Below that, position for the label showing
#whose turn it is to keep it centered.
var redTurn: bool = true
var redLabelPos: Vector2 = Vector2(172, 30)
var blackLabelPos: Vector2 = Vector2(167, 30)


###Scene Functions##############################################################

#_ready() is run once when the scene is loaded. randomize() randomizes all 
#future random seeds in the program.
func _ready():
	randomize()

###Game Functions###############################################################
func dropTile(column: int):
	var row: int = 6
	var endNum: int = 0
	var incNum: int = 1
	
	#Simple loop that checks each row of the column provided as the functions 
	#parameter. Starts at the bottom, and places an appropriate token if it 
	#finds an empty cell.
	while (row >= endNum): 
		if board[column][row] == emptyTile:
			var placeTile = get_node("Board/%d%d/Sprite" % [column, row])
			
			#If it's reds turn, place token sprite on appropriate cell, and 
			#switch all states to black's turn.
			if redTurn == true:
				placeTile.texture = RED
				board[column][row] = redTile
				redTurn = false
				$TopText.text = "Black Turn"
				$TopText.set_position(blackLabelPos)
				
				#If playing a CPU opponent, disable buttons so you can't take 
				#the CPUs turn while waiting for it to "think".
				if Singleton.singlePlayer == true: 
					var buttons = 7
					for i in buttons:
						var disableButton = get_node("Board/Col%dButton" % [i + 1])
						disableButton.disabled = true
				
				break
				
			elif redTurn == false:
				placeTile.texture = BLACK
				board[column][row] = blackTile
				redTurn = true
				$TopText.text = "Red Turn"
				$TopText.set_position(redLabelPos)
				
				#Enable buttons at the end of CPUs turn, if playing against the
				#CPU.
				if Singleton.singlePlayer == true:
					var buttons = 7
					for i in buttons:
						var disableButton = get_node("Board/Col%dButton" % [i + 1])
						disableButton.disabled = false
				
				break
				
		else:
			row -= incNum
	
	#Perform all win checks after each token is placed
	winCheck()
	
	#Had to add this as the CPU would instantly fill the entire board at the 
	#begining of its first turn.
	if Singleton.singlePlayer == true && redTurn == false:
		cpuTakeTurn()

#Simple function that runs through all four WinCheck functions.
func winCheck():
	winCheckHorizontal()
	winCheckVertical()
	winCheckDiagonalDown()
	winCheckDiagonalUp()

#Checks each possible combination of tiles that could combine to a horizontal
#win within nested for loops. Disables token placement buttons, displays 
#message, and adds button to return to menu on game end.
func winCheckHorizontal():
	var buttons: int = 7
	var rowChecks: int = 7
	var colChecks: int = 4
	
	for i in rowChecks:
		for j in colChecks:
			if (board[j][i] == 1) && (board[j + 1][i] == 1) && \
			(board[j + 2][i] == 1) && (board[j + 3][i] == 1):
				$TopText.text = "Red Wins!"
				for k in buttons:
					var disableButton = get_node("Board/Col%dButton" % [k + 1])
					disableButton.disabled = true
				$BackToMenuButton.visible = true
				redTurn = true
			elif(board[j][i] == 2) && (board[j + 1][i] == 2) && \
			(board[j + 2][i] == 2) && (board[j + 3][i] == 2):
				$TopText.text = "Black Wins!"
				for k in buttons:
					var disableButton = get_node("Board/Col%dButton" % [k + 1])
					disableButton.disabled = true
				$BackToMenuButton.visible = true
				redTurn = true

#Same as above, but vertical combinations.
func winCheckVertical():
	var buttons: int = 7
	var colChecks: int = 7
	var rowChecks: int = 4
	
	for i in colChecks:
		for j in rowChecks:
			if (board[i][j] == 1) && (board[i][j + 1] == 1) && \
				(board[i][j + 2] == 1) && (board[i][j + 3] == 1):
				$TopText.text = "Red Wins!"
				for k in buttons:
					var disableButton = get_node("Board/Col%dButton" % [k + 1])
					disableButton.disabled = true
				$BackToMenuButton.visible = true
				redTurn = true
			elif(board[i][j] == 2) && (board[i][j + 1] == 2) && \
			(board[i][j + 2] == 2) && (board[i][j + 3] == 2):
				$TopText.text = "Black Wins!"
				for k in buttons:
					var disableButton = get_node("Board/Col%dButton" % [k + 1])
					disableButton.disabled = true
				$BackToMenuButton.visible = true
				redTurn = true

#Diagonal going down combinations...
func winCheckDiagonalDown():
	var buttons: int = 7
	var colChecks: int = 4
	var rowChecks: int = 4
	
	for i in colChecks:
		for j in rowChecks:
			if (board[i][j] == 1) && (board[i + 1][j + 1] == 1) && \
				(board[i + 2][j + 2] == 1) && (board[i + 3][j + 3] == 1):
				$TopText.text = "Red Wins!"
				for k in buttons:
					var disableButton = get_node("Board/Col%dButton" % [k + 1])
					disableButton.disabled = true
				$BackToMenuButton.visible = true
				redTurn = true
			elif(board[i][j] == 2) && (board[i + 1][j + 1] == 2) && \
			(board[i + 2][j + 2] == 2) && (board[i + 3][j + 3] == 2):
				$TopText.text = "Black Wins!"
				for k in buttons:
					var disableButton = get_node("Board/Col%dButton" % [k + 1])
					disableButton.disabled = true
				$BackToMenuButton.visible = true
				redTurn = true

#Diagonal going up combinations...
func winCheckDiagonalUp():
	var buttons: int = 7
	var colChecks: int = 4
	var rowChecks: int = 4
	
	for i in colChecks:
		for j in rowChecks:
			if (board[i][j + 3] == 1) && (board[i + 1][j + 2] == 1) && \
				(board[i + 2][j + 1] == 1) && (board[i + 3][j] == 1):
				$TopText.text = "Red Wins!"
				for k in buttons:
					var disableButton = get_node("Board/Col%dButton" % [k + 1])
					disableButton.disabled = true
				$BackToMenuButton.visible = true
				redTurn = true
			elif(board[i][j + 3] == 2) && (board[i + 1][j + 2] == 2) && \
			(board[i + 2][j + 1] == 2) && (board[i + 3][j] == 2):
				$TopText.text = "Black Wins!"
				for k in buttons:
					var disableButton = get_node("Board/Col%dButton" % [k + 1])
					disableButton.disabled = true
				$BackToMenuButton.visible = true
				redTurn = true

#WooWoo! Game AI! This is the function that controls the CPU players behavior.
#It's actually quite underwhelming. I create an array where each element 
#corresponds to a column. I then shuffle that list. The first elements column
#is checked to ensure there is at least one open tile. If not that first
#element is removed and the second element is checked, and so on. The timer
#is there so the CPU takes between 1 and 3 seconds to place their tile. It's no
#fun when the opponent keeps instantly spitting moves back at you.

#TL;DR: The CPU AI just picks a random column, ensures that there's at least
#one empty tile, and places if there is. Keeps trying until it finds somewhere
#to place a token or runs out of columns.
func cpuTakeTurn():
	var cpuColArray = [0, 1, 2, 3, 4, 5, 6]
	var timerSet = rand_range(1.0, 3.0)
	cpuColArray.shuffle()
	
	yield(get_tree().create_timer(timerSet), "timeout")
	
	while (redTurn != true):
		if board[cpuColArray[0]][0] == 0:
			dropTile(cpuColArray[0])
		else:
			cpuColArray.pop_front()
	

#These functions just control the various buttons. The Col functions just
#run the dropTile function on their respective columns.
func _on_Col1Button_pressed():
	dropTile(0)

func _on_Col2Button_pressed():
	dropTile(1)

func _on_Col3Button_pressed():
	dropTile(2)

func _on_Col4Button_pressed():
	dropTile(3)

func _on_Col5Button_pressed():
	dropTile(4)

func _on_Col6Button_pressed():
	dropTile(5)

func _on_Col7Button_pressed():
	dropTile(6)

func _on_BackToMenuButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
