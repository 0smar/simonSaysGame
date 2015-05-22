----------------------------------------------- Game
local scenePath = ...
local composer = require("composer")
local score = require("libs.score")

local game = composer.newScene() 
----------------------------------------------- Variables

local backgroundLayer
local textLayer
local answerLayer
local bg
local textBubble
local answerSlotGroup
local answerShapeGroup
local canAnswer
local time
local commandText
local answersList
local answers 
local command
local scoreText
local heartList
local lifeCount
local time
local timeLabel
local timerV

----------------------------------------------- Constants

local COLORS = {
    [1] = {rgb={213/255, 0, 0}, colorName="Red"}, --Red
    [2] = {rgb={255/255, 193/255, 7/255}, colorName="Yellow"}, --Amber
    [3] = {rgb={139/255, 195/255, 74/255}, colorName="Green"},  --Light Green
    [4] = {rgb={3/255, 169/255,244/255}, colorName="Blue"}, --Light Blue
    [5] = {rgb={156/255, 39/255, 176/255}, colorName="Purple"} --Purple
}

local WHITE_COLOR = {1,1,1}
local GRAY_COLOR = {66/255, 66/255, 66/255}
local MARGIN_ANSWER = 260
local MARGIN_HEART = 50
local FONT = native.newFont("Bebas Neue Regular", 16)

local SHAPES = {
    [1] = {name="Circle", img="images/circle.png"},
    [2] = {name="Square", img="images/square.png"},
    [3] = {name="Triangle", img="images/triangle.png"},
    [4] = {name="Star", img="images/star.png"}
}

local POSITIONS = {
    [1] = "Left",
    [2] = "Center",
    [3] = "Right"
}

----------------------------------------------- Functions

local function shuffleTable( t )
    local rand = math.random 
    local iterations = #t
    local j
    
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

local function gameOver()
    local options = {
        effect = "slideUp",
        time = 400,
        params = { score=score.get() }
    }
    composer.gotoScene("results", options)
end

local function setBoard()

    display.remove(answerShapeGroup)

    shuffleTable(SHAPES)

    answers[1] = SHAPES[1]
    answers[2] = SHAPES[2]
    answers[3] = SHAPES[3]

    local answerPool = {}

    answerShapeGroup = display.newGroup()
    answerLayer:insert(answerShapeGroup)

    for indexSlot=1, 3 do
        local answerShape = display.newImage(answers[indexSlot].img)
        answerShape.x = answersList[indexSlot].x
        answerShape.y = answersList[indexSlot].y
        answerShape.xScale = 0.5
        answerShape.yScale = 0.5
        answersList[indexSlot].shapeName = answers[indexSlot].name
        local color = COLORS[math.random(1,#COLORS)]
        answerShape:setFillColor(unpack( color.rgb ))
        answersList[indexSlot].color = color.colorName
        answersList[indexSlot].position = POSITIONS[indexSlot]
        answerShapeGroup:insert(answerShape)

        answerPool[#answerPool+1] = answers[indexSlot].name 
        answerPool[#answerPool+1] = color.colorName
        answerPool[#answerPool+1] = POSITIONS[indexSlot]

    end

    shuffleTable(answerPool)

    commandText.text = answerPool[1]
    command = commandText.text
    commandText:setFillColor(unpack(COLORS[math.random(1,#COLORS)].rgb))
end

local function tap(event)
    if canAnswer then
        local shape = event.target

        if shape.shapeName == command or shape.color == command or shape.position == command then
            score.add(10)
            setBoard()
        else
            if lifeCount<=2 then
                transition.to(heartList[lifeCount], {time=0, onComplete = function() 
                    heartList[lifeCount-1]:setFillColor(unpack(WHITE_COLOR))
                end})
                setBoard()
            end

            lifeCount = lifeCount +1

            if lifeCount == 3 then
                canAnswer = false
                local tempScore = score.load()
                local currScore = score.get()
                if currScore > tempScore then
                    score.save()
                end
                timer.performWithDelay(500, gameOver)
            end                       
        end
    end

    return true
end

local function decreaseTime(event)
    time = time - 1
    timeLabel.text = time 

    if time == 0 then
        canAnswer = false
        gameOver()
        timer.cancel(event.source)
    end
end

local function countdown(stepNumber)
    if stepNumber > 0 then
        local options = 
        {
            text = stepNumber,     
            x = textBubble.x,
            y = textBubble.y - 20,
            width = 128,
            font = FONT,   
            fontSize = 110,
            align = "center",
        }

        local text = display.newText(options)
        text:setFillColor(unpack(COLORS[stepNumber].rgb))
        textLayer:insert(text)

        transition.to(text, {time=1000, xScale = 2, yScale = 2, alpha = 0, onComplete = function() 
            text:removeSelf()
            countdown(stepNumber - 1)
        end})
    end

    if stepNumber == 0 then
        canAnswer = true
        setBoard()
        timerV = timer.performWithDelay(1000,decreaseTime,60)
    end
end

local function setAnswerSlots()

    local totalWidth = 2 * MARGIN_ANSWER
    local startX = display.contentCenterX - totalWidth * 0.5

    answerSlotGroup = display.newGroup()
    answerLayer:insert(answerSlotGroup)

    for index = 1, 3 do
        local answerSlot = display.newImage("images/answer.png")
        answerSlot.x = startX + (index - 1) * MARGIN_ANSWER
        answerSlot.y = display.viewableContentHeight + answerSlot.height
        answersList[#answersList+1] = answerSlot
        answerSlot:addEventListener("tap", tap)
        answerSlotGroup:insert(answerSlot)

        transition.to(answerSlot, {delay = 1600, time = 1400 , transition = easing.outElastic, y = display.viewableContentHeight - answerSlot.height*0.9})
    end
end

local function initialize()
    
    textBubble.xScale = 1
    textBubble.yScale = 1
    transition.to(textBubble, {delay = 800, time = 800, xScale = 1.8, yScale = 1.8, transition = easing.outElastic})

    answersList = {}
    answers = {}
    commandText.text = ""
    time = 60
    timeLabel.text = 60
    score.set(0)
    setAnswerSlots()
    transition.to(textBubble, {delay=2000, onComplete = function() countdown(3) end})

    lifeCount = 1
    for index = 1, 2 do
        heartList[index]:setFillColor(unpack(COLORS[1].rgb))
    end
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
    bg:setFillColor(unpack(GRAY_COLOR))
    backgroundLayer:insert(bg)

    textBubble = display.newImage("images/bubble.png")
    textBubble.x = display.contentCenterX
    textBubble.y = display.contentCenterY - textBubble.height*0.3
    textLayer:insert(textBubble)

    local scoreOptions = 
    {
        text = "Score: ",     
        x = 130,
        y = 50,
        width = 200,
        font = FONT,   
        fontSize = 30,
        align = "left",
    }

    local scoreLabel = display.newText(scoreOptions)
    textLayer:insert(scoreLabel)

    scoreText = score.init({
       fontSize = 30,
       font = FONT,
       x = scoreLabel.x + scoreLabel.width*0.35,
       y = 50,
       maxDigits = 6,
       leadingZeros = true,
       filename = "scorefile.txt",
    })

    textLayer:insert(scoreText)

    local totalWidth = 1 * MARGIN_HEART
    local startX = display.contentCenterX*1.8 - totalWidth * 0.5

    heartList = {}

    for i=1, 2 do
        local heart = display.newImage("images/heart.png")
        heart.x = startX + (i - 1) * MARGIN_HEART
        heart.y = 70
        heart.xScale = 0.2
        heart.yScale = 0.2
        heartList[#heartList+1] = heart
        backgroundLayer:insert(heart)
    end

    local options = 
    {
        text = "",     
        x = textBubble.x,
        y = textBubble.y - 20,
        width = display.viewableContentWidth,
        font = FONT,   
        fontSize = 80,
        align = "center",
    }

    commandText = display.newText(options)
    textLayer:insert(commandText)

    local timeOptions = 
    {
        text = "",     
        x = display.contentCenterX,
        y = scoreLabel.y+20,
        width = display.viewableContentWidth,
        font = FONT,   
        fontSize = 80,
        align = "center",
    }

    timeLabel = display.newText(timeOptions)
    textLayer:insert(timeLabel)
    
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
        display.remove(answerSlotGroup)
        display.remove(answerShapeGroup)
        timer.cancel(timerV)
    end
end
----------------------------------------------- Execution
game:addEventListener( "create" )
game:addEventListener( "destroy" )
game:addEventListener( "hide" )
game:addEventListener( "show" )

return game
