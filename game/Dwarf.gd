extends KinematicBody2D

# score
var depth : int = 0

# environment variables
var speed : int = 200
var jumpforce : int = 400
var gravity : int = 800

var velocity : Vector2 = Vector2()

#var vel_y : int = 0
#var vel_y_old : int = 0
#var previous_frame_floor : bool = true

#onready var sprite : Sprite = get_node("Sprite")
onready var _animated_sprite = $AnimatedSprite
onready var _magic_sprite = $"magic sprite"
onready var _magic_sound = $poof

func get_input():
    
    # movement input here
    if Input.is_action_pressed("move_left"):
        velocity.x -= speed                                                     # Make go fast
        
    elif Input.is_action_pressed("move_right"):
        velocity.x += speed                                                     # Make go fast

    else:
        _animated_sprite.play("idle")                                            # return to idle
        
    if Input.is_action_just_pressed("move_left"):
        _animated_sprite.flip_h = true                                          # spin guy in right direction
        _animated_sprite.play("walk")                                           # sprite animation
    elif Input.is_action_just_pressed("move_right"):
        _animated_sprite.flip_h = false                                         # spin guy in right direction
        _animated_sprite.play("walk")                                           # sprite animation
    
        # jump input
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y -= jumpforce
        if velocity.x < 0:                                                      # backflip city
            for _x in range(30): #16
                _animated_sprite.rotation_degrees += 360/30  #22.5
                yield(get_tree().create_timer(0.4/30),"timeout")
        elif velocity.x >= 0:
            for _x in range(30): #16
                _animated_sprite.rotation_degrees -= 360/30  #22.5
                yield(get_tree().create_timer(0.4/30),"timeout")

func _physics_process(delta):
    velocity.x = 0
    get_input()
    
    # applying the velocity
    velocity = move_and_slide(velocity, Vector2.UP)
    
    # gravity
    velocity.y += gravity * delta
    
    checkScroll()
    checkTeleport()
    #print(str(position))

# Called every frame. 'delta' is the elapsed time since the previous frame.   
func _process(delta):
    #print("current Tile: " + str(getCurrentTile()))
    $"/root/Control/Score".text = str(getTileHB($"/root/Control/Gamefield".field[getCurrentTile().y][getCurrentTile().x]))
    
func checkScroll():
    if get_parent().getRow(position.y) > 1 and is_on_floor() and not get_parent().scrolling:
        get_parent().scroll()
        #velocity.y = 0
  
#    if previous_frame_floor != is_on_floor() and vel_y == 13:                   #will only trigger once
#        print(is_on_floor())
#        print(previous_frame_floor)
#        print("JUST TOOK DAMAGE MATE")
#        _animated_sprite.play("damage")
#        yield (_animated_sprite, "animation_finished")
#        _animated_sprite.play("idle")
#        previous_frame_floor = true
#
#    previous_frame_floor = is_on_floor()

func getCurrentTile():
    return $"/root/Control/Gamefield".getCord(position.x, position.y)
    
func getTileHB(tile):
    return tile.hitbox
    
func checkTeleport():
    var gamefield = $"/root/Control/Gamefield"
    var modifier = 0.17
    #print(position.x)
    var left_define = (gamefield.tile_basesize * gamefield.tile_scaling)/2 * (1.0 + modifier)
    var right_define = (gamefield.tile_basesize * gamefield.tile_scaling)/2 * (1.0 - modifier) + (gamefield.tile_basesize * gamefield.tile_scaling * gamefield.fieldsize_width)
    #print(left_define)
    #print(right_define)
    
    if position.x <= left_define:
        position.x = right_define - 0.3
        teleportEffect()
        
    elif position.x >= right_define:
        position.x = left_define + 0.3
        teleportEffect()


     
func teleportEffect():
    _magic_sound.play()
    if not _magic_sprite.playing:
        _magic_sprite.play("poof")

        yield(get_tree().create_timer(.1),"timeout")
        while _magic_sprite.frame != 0:
            yield(get_tree().create_timer(.01),"timeout")
        _magic_sprite.stop()
        _magic_sound.stop()
    
    
                
    

