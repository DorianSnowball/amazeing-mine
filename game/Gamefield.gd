extends Node2D

var tile_tube = load("res://Tile_Tube.tscn")
var tile_corner = load("res://Tile_Corner.tscn")
var tile_end_piece = load("res://Tile_End_Piece.tscn")
var tile_T_piece = load("res://Tile_T_Piece.tscn")
var tile_intersection = load("res://Tile_Intersection.tscn")

var arrow_button = load("res://Arrow_Button.tscn")

var tile_list = [tile_tube, tile_corner, tile_end_piece, tile_T_piece, tile_intersection]

# Declare member variables here. Examples:
var fieldsize_width : int = 5
var fieldsize_height : int = 5

var tile_scaling = 2
var tile_basesize = 64

var field : = []




# Called when the node enters the scene tree for the first time.
func _ready():
    # init 2d array
    for x in range(fieldsize_height):
        field.append([])
        field[x]=[]        
        for y in range(fieldsize_width):
            field[x].append([])
            field[x][y]=0
            
    # draw field and test insert functions
    generateRandomField()
    drawArrows()
    drawField()
    spawnDwarf()

func insertRow(left, rowIdx, tile):
    var row = field[rowIdx]
    if left:
        row.push_front(tile)
        $".".remove_child(row.pop_back())
    else:
        row.push_back(tile)
        $".".remove_child(row.pop_front())

    drawField()
        
func insertCol(top, colIdx, tile):
    var col = []
    for i in field:
        col.push_back(i[colIdx])
        
    if top:
        col.push_front(tile)
    else:
        col.push_back(tile)
    
    if top:
        $".".remove_child(col.pop_back())
    else:
        $".".remove_child(col.pop_front())
    
    var j = 0
    for i in field:
        i[colIdx] = col[j]
        j+=1
    drawField()
    
func generateRandomField():
    randomize()
    tile_list.shuffle()
    var i = 0
    var j = 0
    for row in field:
        for node in row:            

            field[i][j] = getRandomTile()
            j+=1
        i+=1
        j=0
    
    # hardcoding the starting tile
    var starting_tile = tile_end_piece.instance()
    starting_tile.rotate(-1.5707963268)
    starting_tile.scale = Vector2(tile_scaling, tile_scaling)
    field[0][0] = starting_tile

func getRandomTile():
    var tile : KinematicBody2D = tile_list[randi() % tile_list.size()].instance()
    tile.scale = Vector2(tile_scaling, tile_scaling)
    
    if randi() % 2 == 1:
        tile.scale.y *= -1
    
    if randi() % 2 == 1:
        tile.scale.x *= -1
    
    tile.rotate((randi() % 4)* 1.5707963268)
    return tile
    
func drawArrows():
    # draw arrows
    for x in range(fieldsize_width + 2):
        for y in range(fieldsize_height + 2):
            var arrow: Node2D = arrow_button.instance()
            var button: TextureButton = arrow.get_child(0)
            button.connect("pressed", self, "arrow_pressed", [Vector2(x,y)])

            arrow.position = Vector2(x*(tile_basesize*tile_scaling), y*(tile_basesize*tile_scaling))
            if x==0 and y in range(1,fieldsize_height+1): # left col    
                arrow.rotation_degrees = -90
                arrow.position.x += tile_basesize / 2
                $".".add_child(arrow)
            if y == 0 and x in range(1,fieldsize_width+1): # top row
                arrow.position.y += tile_basesize / 2
                $".".add_child(arrow)
            if x == fieldsize_width+1 and y in range(1, fieldsize_height+1): # right col
                arrow.rotation_degrees = 90
                arrow.position.x -= tile_basesize / 2
                $".".add_child(arrow)
            if y == fieldsize_height+1 and x in range(1,fieldsize_width+1): # bot row
                arrow.rotation_degrees = 180
                arrow.position.y -= tile_basesize / 2
                $".".add_child(arrow)
                
func drawField():
    var i = 0
    var j = 0
       
    # draw tiles
    for row in field:
        for node in row:

            node.position = Vector2((j+0.5)*(tile_basesize*tile_scaling)+tile_basesize,(i+0.5)*(tile_basesize*tile_scaling)+tile_basesize)
            
            if node.get_parent() == null:
                $".".add_child(node)
                
            j+=1
        i+=1
        j=0
    
var dwarf = null
func spawnDwarf():
    dwarf = load("res://Dwarf.tscn").instance()
    dwarf.position = Vector2(32+(tile_basesize*tile_scaling), 32+(tile_basesize*tile_scaling))
    $".".add_child(dwarf)

#func getRow(y):
#    return int(y-tile_basesize) / (tile_basesize * tile_scaling)
#
#func getCol(x):
#    return int(x-tile_basesize) / (tile_basesize * tile_scaling)
#
#func getCord(x,y):
#    return Vector2(getCol(x), getRow(y))
    
func arrow_pressed(pos):
    if pos.x == 0: # left row button pressed
        insertRow(true, pos.y-1, getRandomTile())
    if pos.x == fieldsize_width+1: # right row button pressed
        insertRow(false, pos.y-1, getRandomTile())
    if pos.y == 0: # top row button pressed
        insertCol(true, pos.x-1, getRandomTile())
    if pos.y == fieldsize_height + 1: # bot row button pressed
        insertCol(false, pos.x-1, getRandomTile())
    
func scroll():
    # remove first row
    # add new last row
    
    var row = []
    for i in range(fieldsize_width):
        row.append(getRandomTile())
        
    var old = field.pop_front()
    for tile in old:
        $".".remove_child(tile)
        
    field.push_back(row)
    dwarf.position.y -= tile_basesize*tile_scaling
    drawField()
    
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
