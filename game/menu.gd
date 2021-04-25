extends Panel

func button_start():
    visible = false

func button_highscore():
    $"Highscore".visible = true
        
func button_settings():
    pass
    
func button_credits():
    $"Credits".visible = true
    
func button_quit():
    get_tree().quit()
    

func _ready():
    $"ButtonStart".connect("pressed",self,"button_start")
    $"ButtonHighscore".connect("pressed",self,"button_highscore")
    $"ButtonSettings".connect("pressed",self,"button_settings")
    $"ButtonCredits".connect("pressed",self,"button_credits")
    $"ButtonQuit".connect("pressed",self,"button_quit")
