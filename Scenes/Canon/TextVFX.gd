extends Label

#-----------------------------Exporting variables-----------------------------*/
@export var speed :int = 5
@export var numberOfFlashes :int = 0
@export var delay :float = 0
@export var fade : bool 
@export var preview : bool = false
@export var start : bool = false
#----------------------------Not Exported variables----------------------------*/
var time = 0.0
var timeSin = 0
var myActualFlash = 0
var sinCycle = 0
var _visible = true


#--------------------------------Initializing --------------------------------*/
func _ready():
	time = 0

##-----------------------------Making things happen-----------------------------*/
func _process(delta):
	
	if start:
		_start()
		start = false
		flashMyText()
	else:
		visible = true
		_visible = true
	
		time += delta
		timeSin = sin(time*speed)
		flashMyText()

#*******************************************************************************/
#-----------------------------------Flashing-----------------------------------*/
#*******************************************************************************/


#-------Start() func initializes the real flash in case it's not looping-------*/
#------User can call start() and eventually give parameters for the flash------*/

func _start(numberOfFlashess:int = 0,speedd:int = 0,fadee:bool = false):
	if numberOfFlashess == 0 and speedd == 0 and !fadee:
		time = 0 
		_visible = true
		visible = true
		myActualFlash = numberOfFlashes
		modulate.a = 0
	else:
		time = 0 
		numberOfFlashes = numberOfFlashess
		speed = speedd
		fade = fadee
		_visible = true
		visible = true
		myActualFlash = numberOfFlashes
		modulate.a = 1


#-----------------------------Here comes the magic-----------------------------*/
func flashMyText():
#-----------------------We check if there a delay time -----------------------*/
	if delay < time:
		if myActualFlash > 0 and numberOfFlashes > 0:
			if !fade:
				if timeSin > 0:
					_visible = true
					if sinCycle == 0:
						sinCycle = 1
				else:
					_visible = false
					if sinCycle == 1:
						sinCycle = 2
				visible = _visible
			else:
				if timeSin > 0:
					if sinCycle == 0:
						sinCycle = 1
				else:
					if sinCycle == 1:
						sinCycle = 2
				modulate.a = timeSin
#------------------Checking if an entair cycle has been done------------------*/
#----------------------This way we keep track of the n of----------------------*/
			if sinCycle == 2 :
				myActualFlash -= 1
				sinCycle = 0
#--------------------------------Looping Flash--------------------------------*/
		if numberOfFlashes == 0:
			if !fade:
				modulate.a = 1
				if timeSin > 0:
					_visible = true
				else:
					_visible = false
				visible = _visible
			else:
				modulate.a = timeSin
		elif myActualFlash <= 0:
			modulate.a = 0
