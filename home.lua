----------------------------------------------- Home
local scenePath = ...
local composer = require("composer")

local game = composer.newScene() 
----------------------------------------------- Variables

local backgroundLayer
local textLayer
local bg 
local playButton
local abletoTap

----------------------------------------------- Constants

local COLORS = {
    [1] = {3/255, 169/255,244/255}, --Light Blue
    [2] = {156/255, 39/255, 176/255}, --Purple
    [3] = {139/255, 195/255, 74/255},  --Light Green
    [4] = {255/255, 193/255, 7/255}, --Amber
    [5] = {213/255, 0, 0} --Red
}

local SCENE_EFFECT = {
    [1] = "slideUp",
    [2] = "slideLeft",
    [3] = "slideRight"
}

local WHITE_COLOR = {1,1,1}

----------------------------------------------- Functions

local function play(event)
    transition.cancel("playAnimation")
	if abletoTap then
		abletoTap = false
		local sceneEffect = math.random(1,#SCENE_EFFECT)

		local options = {
			effect = SCENE_EFFECT[sceneEffect],
			time = 800,
		}

		transition.to(playButton, {time = 1000, rotation = 360, onComplete = function()
			composer.gotoScene("game", options)
		end})
	end
    return true
end

local function animatePlayButton()
    transition.to(playButton, {tag = "playAnimation", time = 800, xScale = 1.3, yScale = 1.3, transition = easing.outQuad, onComplete = function()
        transition.to(playButton, {time = 800, xScale = 1, yScale = 1, transition = easing.inQuad, onComplete = function()
            animatePlayButton()
        end})
    end})
end

local function initialize()
    local randomColor = math.random(1, #COLORS)
    bg:setFillColor( unpack(COLORS[randomColor]) )
	
	abletoTap = true
    playButton.xScale = 1
    playButton.yScale = 1
    playButton.rotation = 0

    animatePlayButton()
end

----------------------------------------------- Module functions 

function game:create(event)
    local sceneView = self.view

    backgroundLayer = display.newGroup()
    sceneView:insert(backgroundLayer)

    textLayer = display.newGroup()
    sceneView:insert(textLayer)

    bg = display.newRect( display.contentCenterX, display.contentCenterY, display.viewableContentWidth, display.viewableContentHeight )
    backgroundLayer:insert(bg)

    playButton = display.newImage("images/playButton.png")
    playButton.x = display.contentCenterX
    playButton.y = display.contentCenterY
    textLayer:insert(playButton)

    playButton:addEventListener("tap", play)
    
end

function game:destroy()
    
end

function game:show( event )
    local sceneGroup = self.view
    local phase = event.phase
        
    if ( phase == "will" ) then
        --print("will show - levels")
        
        initialize(event)

    elseif ( phase == "did" ) then
        
    end
end

function game:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        
    elseif ( phase == "did" ) then
    end
end
----------------------------------------------- Execution
game:addEventListener( "create" )
game:addEventListener( "destroy" )
game:addEventListener( "hide" )
game:addEventListener( "show" )

return game
