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
            for x in range(30): #16
                _animated_sprite.rotation_degrees += 360/30  #22.5
                yield(get_tree().create_timer(0.4/30),"timeout")
        elif velocity.x >= 0:
            for x in range(30): #16
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
    
func checkScroll():
    if getRow(position.y) > 1:
        get_parent().scroll()

func getRow(y):
    return int(y-get_parent().tile_basesize) / (get_parent().tile_basesize * get_parent().tile_scaling)
    
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
     
    
    
                
    

