----------------------------------------------------------------
-- Star no Samurai スターのさむらい ✪
-- Alessandro Stamatto & Juvane Nunes
-- Projeto de Introdução a desenvolvimento de Jogos
----------------------------------------------------------------

-- Global parameters
shipStartX = 76 shipStartY = 50 shipWidth = 21 shipHeigth = 55
starLife = 8 starWidth = 80 starHeigth = 78 starX = 0 starY = 0
kanaAt = {} kanaTime = 24 screenKanas = {}
enemies = {} enemyTime = 8 enemyWidth = 45 enemyHeigth = 70 enemyTimeSpeed = 12
aSerDestruido = 4 killed = 0 saiuDoLugar = false
bottom = -225 top = 225
right = 325 left = -325 middle = 0
moving = false
input = ""

-- Global Japonese Alphabet
kana = {a="あ", i="い", u="う", e="え", o="お", ka="か", ki= "き", ku="く", ke="け", ko="こ", ga="が", gi="ぎ", gu="ぐ", ge="げ", go="ご", 
sa="さ", shi="し", su="す", se="せ", so="そ", za="ざ", ji="じ", zu="ず", ze="ぜ", zo="ぞ", ta="た", chi="ち", tsu="つ", te="て", to="と", 
da="だ", di="ぢ", du="づ", de="で", ["do"]="ど", na="な", ni="に", nu="ぬ", ne="ね", no="の", ha="は", hi="ひ", fu="ふ", he="へ", ho="ほ", 
ba="ば", bi="び", bu="ぶ", be="べ", bo="ぼ", pa="ぱ", pi="ぴ", pu="ぷ", pe="ぺ", po="ぽ", ma="ま", mi="み", mu="む", me="め", mo="も", ya="や", 
yu="ゆ", yo="よ", ra="ら", ri="り", ru="る", re="れ", ro="ろ", wa="わ", wo="を", n="ん", star="✪"}
---------------------
rkana = {["あ"]="a", ["い"]="i", ["う"]="u", ["え"]="e", ["お"]="o", ["か"]="ka", ["き"]= "ki", ["く"]="ku", ["け"]="ke", ["こ"]="ko", ["が"]="ga", 
["ぎ"]="gi", ["ぐ"]="gu", ["げ"]="ge", ["ご"]="go", ["さ"]="sa", ["し"]="shi", ["す"]="su", ["せ"]="se", ["そ"]="so", ["ざ"]="za", ["じ"]="ji", 
["ず"]="zu", ["ぜ"]="ze", ["ぞ"]="zo", ["た"]="ta", ["ち"]="chi", ["つ"]="tsu", ["て"]="te", ["と"]="to", ["だ"]="da", ["ぢ"]="di", ["づ"]="du", 
["で"]="de", ["ど"]="do", ["な"]="na", ["に"]="ni", ["ぬ"]="nu", ["ね"]="ne", ["の"]="no", ["は"]="ha", ["ひ"]="hi", ["ふ"]="fu", ["へ"]="he", 
["ほ"]="ho", ["ば"]="ba", ["び"]="bi", ["ぶ"]="bu", ["べ"]="be", ["ぼ"]="bo", ["ぱ"]="pa", ["ぴ"]="pi", ["ぷ"]="pu", ["ぺ"]="pe", ["ぽ"]="po", 
["ま"]="ma", ["み"]="mi", ["む"]="mu", ["め"]="me", ["も"]="mo", ["や"]="ya", ["ゆ"]="yu", ["よ"]="yo", ["ら"]="ra", ["り"]="ri", ["る"]="ru", 
["れ"]="re", ["ろ"]="ro", ["わ"]="wa", ["を"]="wo", ["ん"]="n", ["✪"]="star"}
chars = "あいうえおかきくけこがぎぐげごさしすせそざじずぜぞたちつてとだぢづでどなにぬねのはひふへほばびぶべぼぱぴぷぺぽまみむめもやゆよらりるれろわをん✪"
kanaTable = {"あ", "い", "う", "え", "お", "か", "き", "く", "け", "こ", "が", "ぎ", "ぐ", "げ", "ご", "さ", "し", "す", "せ",
"そ", "ざ", "じ", "ず", "ぜ", "ぞ", "た", "ち", "つ", "て", "と", "だ", "ぢ", "づ", "で", "ど", "な", "に", "ぬ", "ね", "の","は",
"ひ", "ふ", "へ", "ほ", "ば", "び", "ぶ", "べ", "ぼ", "ぱ", "ぴ", "ぷ", "ぺ", "ぽ", "ま", "み", "む", "め", "も", "や", "ゆ", "よ",
"ら", "り", "る", "れ", "ろ", "わ", "を", "ん", "✪"}
font = MOAIFont.new()
font:loadFromTTF('font.ttc',chars,60,72)

-- Auxilar functions
function angle (x1, y1, x2, y2)
	return math.atan2 (y2 - y1, x2 - x1) * (180/math.pi)
end

function distance (x1, y1, x2, y2)
	return math.sqrt( ((x2 - x1) ^2) + ((y2 - y1) ^ 2) )
end

function testShipHit (enemy)
	
	shipX, shipY = ship:getLoc()
	enemyX, enemyY = enemy:getLoc()
	
	--print (shipX .. " " .. shipY .. " " .. enemyX .. " " .. enemyY .. " " .. shipWidth .. " " .. shipHeigth .. " " .. enemyWidth .. " " .. enemyHeigth)

	shipRight = shipX + shipWidth shipLeft = shipX - shipWidth
	shipTop = shipY + shipHeigth shipBottom = shipY - shipHeigth
	enemyRight = enemyX + enemyWidth enemyLeft = enemyX - enemyWidth
	enemyTop = enemyY + enemyHeigth enemyBottom = enemyY - enemyHeigth

	shipOutsideTop = shipBottom > enemyTop
	shipOutsideBottom = shipTop < enemyBottom
	shipOutsideRight = shipLeft > enemyRight
	shipOutsideLeft  = shipRight < enemyLeft

	return not (shipOutsideLeft or shipOutsideRight or shipOutsideBottom or shipOutsideTop)
end

print("Iniciando jogo!")

-- Creates and configures the Game Window
MOAISim.openWindow ( "Star no Samurai", 800, 600 )
viewport = MOAIViewport.new ()
viewport:setSize ( 800, 600 )
viewport:setScale ( 800, 600 )

-- Sets the background
background = MOAILayer2D.new ()
background:setViewport ( viewport )
MOAISim.pushRenderPass ( background )
-- Load the space sprite image
spaceSprite = MOAIGfxQuad2D.new()
spaceSprite:setTexture ("./sprites/background/space.jpg")
spaceSprite:setRect(-400, -300, 400, 300)
-- Creates the space Prop and insert it in the background layer
space = MOAIProp2D.new()
space:setDeck (spaceSprite)
space:setLoc(0, 0)
background:insertProp(space)

-- Create main layer and push it to the render stack
layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
MOAISim.pushRenderPass ( layer )

-- Load the star sprite image
starSprite = MOAIGfxQuad2D.new()
starSprite:setTexture ("./sprites/heroes/star.png")
starSprite:setRect(-starWidth, -starHeigth, starWidth, starHeigth)
-- Creates the star Prop and insert it in the main layer
star = MOAIProp2D.new()
star:setDeck (starSprite)
star:setLoc(starX, starY)
layer:insertProp(star)

-- Load the ship sprite image
shipSprite = MOAIGfxQuad2D.new()
shipSprite:setTexture ("./sprites/heroes/ship.png")
shipSprite:setRect(-shipWidth, -shipHeigth, shipWidth, shipHeigth)
-- Creates the ship Prop and insert it in the main layer
ship = MOAIProp2D.new()
ship:setDeck (shipSprite)
ship:setLoc(shipStartX, shipStartY)
layer:insertProp(ship)

-- Load the enemy sprite image
enemySprite = MOAIGfxQuad2D.new()
enemySprite:setTexture ("./sprites/enemies/gyo.png")
enemySprite:setRect (-enemyWidth, -enemyHeigth, enemyWidth, enemyHeigth)

-- Starts the kanas positions
function startKanas ()

	kanaAt.topLeft = MOAITextBox.new()
	kanaAt.topRight = MOAITextBox.new()	
	kanaAt.bottomLeft = MOAITextBox.new()
	kanaAt.bottomRight = MOAITextBox.new()
	kanaAt.topMiddle  = MOAITextBox.new()
	kanaAt.bottomMiddle  = MOAITextBox.new()
	kanaAt.rightMiddle  = MOAITextBox.new()
	kanaAt.leftMiddle  = MOAITextBox.new()			

	for name, text in pairs(kanaAt) do
		text:setFont(font)
		text:setTextSize(90,60)
		text:setYFlip(true)
		text:setRect(-50,-50,50,50)
		layer:insertProp (text)
	end

	kanaAt.topLeft:setLoc(left, top)
	kanaAt.topRight:setLoc(right, top)
	kanaAt.bottomLeft:setLoc(left, bottom)
	kanaAt.bottomRight:setLoc(right, bottom)
	kanaAt.bottomMiddle:setLoc(middle, bottom)
	kanaAt.topMiddle:setLoc(middle, top)
	kanaAt.rightMiddle:setLoc(right, middle)
	kanaAt.leftMiddle:setLoc(left, middle)

	print("Funcao startKanas!")
end

function randomKana(x)
	equal = true
	local k = nil
	while equal do
		equal = false
		k = kanaTable[math.random(#kanaTable)]
		for _, value in pairs(screenKanas) do
			if k == value then
				equal = true
			end
		end
	end

	print(rkana[k])
	x:setString(k)
	x.kana = k
	return k
end

--Randomize the kanas
function randomizeKanas ()
	screenKanas.topLeft = randomKana(kanaAt.topLeft)
	screenKanas.topRight = randomKana(kanaAt.topRight)
	screenKanas.bottomLeft = randomKana(kanaAt.bottomLeft)
	screenKanas.bottomRight = randomKana(kanaAt.bottomRight)
	screenKanas.topMiddle = randomKana(kanaAt.topMiddle)
	screenKanas.bottomMiddle = randomKana(kanaAt.bottomMiddle)
	screenKanas.rightMiddle = randomKana(kanaAt.rightMiddle)
	screenKanas.leftMiddle = randomKana(kanaAt.leftMiddle)
end

function shipMove (targetY, targetX)
	function ship:Move()
		local shipTimeSpeed = 0.75
		if not moving then
			moving = true
			saiuDoLugar = true
			MOAIThread.blockOnAction (self:seekLoc (targetX, targetY, shipTimeSpeed, MOAIEaseType.LINEAR))
			moving = false
		end
	end
	ship.Thread = MOAIThread.new()
	ship.Thread:run (ship.Move, ship)
end

function makeEnemy()
	local enemy = MOAIProp2D.new()
	enemy:setDeck(enemySprite)
	layer:insertProp(enemy)
	local wall = math.random(1,4)
	if wall == 1 then
		enemy:setLoc (math.random(left, right), top+50)
	elseif wall == 2 then
		enemy:setLoc (math.random(left, right), bottom-50)
	elseif wall == 3 then
		enemy:setLoc (left-50, math.random(bottom, top))
	elseif wall == 4 then
		enemy:setLoc (right+50, math.random(bottom, top))
	end
	local startX, startY = enemy:getLoc()
	enemy:setRot(angle(startX, startY, 0, 0)-90)
	enemyMove(enemy)
	enemies[enemy] = true
end	

function enemyMove(enemy)
	
	enemy.Thread = MOAIThread.new()
	enemy.hitThread = MOAIThread.new()

	function enemy:Move()
		MOAIThread.blockOnAction (self:seekLoc (0, 0, enemyTimeSpeed, MOAIEaseType.LINEAR))
		starLife = starLife - 1
		print ("Vida da estrela: " .. starLife)
		enemy:die(false)
	end

	function enemy:checkHit()
		while true do
			if testShipHit (enemy) and saiuDoLugar then
				enemy:die(true)
			end
			coroutine.yield()
		end
	end

	function enemy:die(destruido)
		layer:removeProp(enemy)
		enemies[enemy] = nil
		enemy.Thread:stop()
		enemy.hitThread:stop()
		if saiuDoLugar and destruido then
			killed = killed + 1
			print ("Inimigos Destruidos: " .. killed)
		end
	end

	enemy.Thread:run (enemy.Move, enemy)
	enemy.hitThread:run (enemy.checkHit, enemy)
end


startKanas ()
randomizeKanas ()

MOAIInputMgr.device.keyboard:setCallback(
    function(key,down)
        if down==true then
        	if not (key >= 65 and key <= 122) then
        		print ("kana ativado!, " .. input)
        		if kana[input] ~= nil then
	                if input == rkana[kanaAt.topLeft.kana] then
	                	shipMove(top, left)
	            	elseif input == rkana[kanaAt.topRight.kana] then
	        			shipMove(top, right)
	        		elseif input == rkana[kanaAt.bottomLeft.kana] then
	    				shipMove(bottom, left)
	    			elseif input == rkana[kanaAt.bottomRight.kana] then
						shipMove(bottom, right)
					elseif input == rkana[kanaAt.topMiddle.kana] then
						shipMove(top, middle)
					elseif input == rkana[kanaAt.bottomMiddle.kana] then
						shipMove(bottom, middle)
					elseif input == rkana[kanaAt.rightMiddle.kana] then
						shipMove(middle, right)
					elseif input == rkana[kanaAt.leftMiddle.kana] then
						shipMove(middle, left)
					end

				end
				input = ""
			else
            	input = input .. string.char(tostring(key))
            	print ("entrada: " .. input)
            end
        end
    end
)

function gameOverMessage (victory)
	local font = MOAIFont.new ()
	font:loadFromTTF ("./arialbd.ttf", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?! =[", 12, 163)
	local textbox = MOAITextBox.new ()
	textbox:setFont ( font )
	textbox:setRect (-160, -80, 160, 80)
	textbox:setAlignment (MOAITextBox.CENTER_JUSTIFY)
	textbox:setYFlip (true)
	textbox:setLoc (middle, top - 150)
	if not victory then
		textbox:setString ("A estrela foi raptada =[")
	else
		textbox:setString ("A estrela foi salva! =D")
	end
	layer:insertProp (textbox)
	textbox:spool ()
end

function gameLoop()
	endKanaTime = os.time() + kanaTime
	endEnemyTime = os.time() + enemyTime

	while true do
		
		if os.time() > endKanaTime then
			randomizeKanas()
			endKanaTime = os.time() + kanaTime
		end
		
		if os.time() > endEnemyTime then
			makeEnemy()
			endEnemyTime = os.time() + enemyTime
		end

		if starLife < 1 then
			print ("Game Over!")
			gameOverMessage(false)
			break
		end

		if killed >= aSerDestruido then
			print ("A estrela foi salva!")
			gameOverMessage(true)
			break
		end

		coroutine.yield()
	end
end

gameThread = MOAIThread.new()
gameThread:run (gameLoop)