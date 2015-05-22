----------------------------------------------- Results
local scenePath = ...
local composer = require("composer")
local score = require("libs.score")

local game = composer.newScene() 
----------------------------------------------- Variables

local backgroundLayer
local textLayer
local answerLayer
local bg
local ysValue
local hsValue

----------------------------------------------- Constants

local COLORS = {
    [1] = {rgb={213/255, 0, 0}, colorName="Red"},
    [2] = {rgb={255/255, 193/255, 7/255}, colorName="Yellow"},
    [3] = {rgb={139/255, 195/255, 74/255}, colorName="Green"},
    [4] = {rgb={3/255, 169/255,244/255}, colorName="Blue"},
    [5] = {rgb={156/255, 39/255, 176/255}, colorName="Purple"}
}

local WHITE_COLOR = {1,1,1}
local GRAY_COLOR = {66/255, 66/255, 66/255}
local FONT = native.newFont("Bebas Neue Regular", 16)

----------------------------------------------- Functions

local function goHome(event)
    composer.gotoScene("home")
    return true
end

local function play(event)
    composer.gotoScene("game")
    return true
end

local function initialize(event)
    local params = event.params

    ysValue.text = params.score
    hsValue.text = score.load()
end

----------------------------------------------- Module functions 

function game:create(event)
    local sceneView = self.view

    backgroundLayer = display.newGroup()
    sceneView:insert(backgroundLayer)

    textLayer = display.newGroup()
    sceneView:insert(textLayer)

    answerLayer = display.newGroup()
    sceneView:insert(answerLayer)

    bg = display.newRect( display.contentCenterX, display.contentCenterY, display.viewableContentWidth, display.viewableContentHeight )
    bg:setFillColor(unpack(COLORS[math.random(1,#COLORS)].rgb))
    backgroundLayer:insert(bg)

    local options = 
    {
        text = "Game Over",     
        x = display.contentCenterX,
        y = display.viewableContentHeight*0.25,
        width = display.viewableContentWidth,
        font = FONT,   
        fontSize = 80,
        align = "center",
    }

    local gameOver = display.newText(options)
    textLayer:insert(gameOver)

    local ysLabelOptions = 
    {
        text = "Your Score",     
        x = display.contentCenterX,
        y = display.contentCenterY-70,
        width = display.viewableContentWidth,
        font = FONT,   
        fontSize = 40,
        align = "center",
    }

    local ysLabel = display.newText(ysLabelOptions)
    textLayer:insert(ysLabel)

    local ysValueOptions = 
    {
        text = "",     
        x = display.contentCenterX,
        y = display.contentCenterY-20,
        width = display.viewableContentWidth,
        font = FONT,   
        fontSize = 75,
        align = "center",
    }

    ysValue = display.newText(ysValueOptions)
    textLayer:insert(ysValue)

    local hsLabelOptions = 
    {
        text = "High-Score",     
        x = display.contentCenterX,
        y = display.contentCenterY+50,
        width = display.viewableContentWidth,
        font = FONT,   
        fontSize = 40,
        align = "center",
    }

    local hsLabel = display.newText(hsLabelOptions)
    textLayer:insert(hsLabel)

    local hsValueOptions = 
    {
        text = "",     
        x = display.contentCenterX,
        y = hsLabel.y + 45,
        width = display.viewableContentWidth,
        font = FONT,   
        fontSize = 55,
        align = "center",
    }

    hsValue = display.newText(hsValueOptions)
    textLayer:insert(hsValue)
    
    local homeButton = display.newImage("images/answer.png")
    homeButton.x = display.contentCenterX - homeButton.width*0.5
    homeButton.y = display.viewableContentHeight*0.8
    homeButton.yScale = 0.5
    backgroundLayer:insert(homeButton)
    homeButton:addEventListener("tap", goHome)
    local homeLabel = display.newText("HOME", homeButton.x, homeButton.y, FONT, 40)
    homeLabel:setFillColor(unpack(GRAY_COLOR))
    textLayer:insert(homeLabel)

    local replayButton = display.newImage("images/answer.png")
    replayButton.x = display.contentCenterX + replayButton.width*0.6
    replayButton.y = display.viewableContentHeight*0.8
    replayButton.yScale = 0.5
    backgroundLayer:insert(replayButton)
    replayButton:addEventListener("tap", play)
    local replayLabel = display.newText("REPLAY", replayButton.x, replayButton.y, FONT, 40)
    replayLabel:setFillColor(unpack(GRAY_COLOR))
    textLayer:insert(replayLabel)
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
