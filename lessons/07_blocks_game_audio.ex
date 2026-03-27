/*******************************************************************************************
*
*   PROJECT:        BLOCKS GAME
*   LESSON 07:      audio
*   DESCRIPTION:    Sounds and music loading and playing
*
*   COMPILATION (Windows - MinGW):
*       gcc -o $(NAME_PART).exe $(FILE_NAME) -lraylib -lopengl32 -lgdi32 -lwinmm -Wall -std=c99
*
*   COMPILATION (Linux - GCC):
*       gcc -o $(NAME_PART).exe $(FILE_NAME) -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
*
*   Example originally created with raylib 2.0, last time updated with raylib 4.2

*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--/*
integer true=1
integer false=0
include std/math.e
--*/
------------------------------------------------------------------------------------
-- Useful values definitions 
------------------------------------------------------------------------------------
integer PLAYER_LIFES        =    5
integer BRICKS_LINES        =    5
integer BRICKS_PER_LINE     =   20

integer BRICKS_POSITION_Y   =   50

------------------------------------------------------------------------------------
-- Types and Structures Definition
------------------------------------------------------------------------------------

-- LESSON 01: Window initialization and screens management
enum   LOGO, TITLE, GAMEPLAY, ENDING  
enum x,y
    -- LESSON 05: Textures loading and drawing
enum tex_width=2,tex_height=3 -- for textures

sequence Player = {
        {0,0},  --position
        {0,0},  --speed
        {0,0},  --size
        {0,0,0,0},  --bounds
        0       --lifes
        }
enum p_position,p_speed,p_size,p_bounds,p_lifes     

sequence Ball ={
        {0,0},  --position
        {0,0},  --speed
        0,      --radius
        0       --active
        }
enum b_position,b_speed,b_radius,b_active

sequence Brick = {
        {0,0},      --position
        {0,0},      --size
        {0,0,0,0},  --bounds
        0,          --resistance
        0           --active
        }
enum br_position,br_size,br_bounds,br_resistance,br_active 
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    -- LESSON 01: Window initialization and screens management
    InitWindow(screenWidth, screenHeight, "PROJECT: BLOCKS GAME") 
    
    -- NOTE: Load resources (textures, fonts, audio) after Window initialization
    
    -- LESSON 05: Textures loading and drawing
    sequence texLogo = LoadTexture("resources/raylib_logo.png")
    sequence texBall = LoadTexture("resources/ball.png")
    sequence texPaddle = LoadTexture("resources/paddle.png")
    sequence texBrick = LoadTexture("resources/brick.png")

    -- LESSON 06: Fonts loading and text drawing
    sequence font = LoadFont("resources/setback.png")

    -- LESSON 07: Sounds and music loading and playing
    InitAudioDevice()               -- Initialize audio system
    
    sequence fxStart = LoadSound("resources/start.wav")
    sequence fxBounce = LoadSound("resources/bounce.wav")
    sequence fxExplode = LoadSound("resources/explosion.wav")
    
    sequence music = LoadMusicStream("resources/qt-plimp.xm")
    --sequence music = LoadMusicStream("resources/blockshock.mod")  --file not in repo
    
    PlayMusicStream(music)      -- Start music streaming

    -- Game required variables
    integer screen = LOGO       -- Current game screen state
    
    integer framesCounter = 0           -- General pourpose frames counter
    integer gameResult = -1             -- Game result: 0 - Loose, 1 - Win, -1 - Not defined
    integer gamePaused = false      -- Game paused state toggle
    
    -- NOTE: Check defined structs on top
    sequence player = Player 
    sequence ball = Ball 
    sequence line=repeat(Brick,BRICKS_PER_LINE)
    sequence bricks=repeat(line,BRICKS_LINES) 
    
    -- Initialize player
    player[p_position] = { screenWidth/2, screenHeight*7/8 } 
    player[p_speed] = { 8.0, 0.0 } 
    player[p_size] = { 100, 24 } 
    player[p_lifes] = PLAYER_LIFES 
    
    -- Initialize ball
    ball[b_radius] = 10.0 
    ball[b_active] = false 
    ball[b_position] = { player[p_position][x] + player[p_size][x]/2, player[p_position][y] - ball[b_radius]*2 } 
    ball[b_speed] = { 4.0, 4.0 } 

    -- Initialize bricks
    for  j = 1 to BRICKS_LINES  
    do
        for  i = 1  to BRICKS_PER_LINE  
        do
            bricks[j][i][br_size] = { screenWidth/BRICKS_PER_LINE, 20 } 
            bricks[j][i][br_position] = { (i-1)*bricks[j][i][br_size][x], (j-1)*bricks[j][i][br_size][y] + BRICKS_POSITION_Y } 
            bricks[j][i][br_bounds] = { bricks[j][i][br_position][x], bricks[j][i][br_position][y], bricks[j][i][br_size][x], bricks[j][i][br_size][y] } 
            bricks[j][i][br_active] = true 
        end for
    end for
        
    SetTargetFPS(60)                -- Set desired framerate (frames per second)
    ----------------------------------------------------------------------------------------
    
    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        -- LESSON 07: Sounds and music loading and playing
        -- NOTE: Music buffers must be refilled if consumed
        UpdateMusicStream(music)
        
        ------------------------------------------------------------------------------------
        switch(screen) 
        do
            case LOGO 
            then
                -- Update LOGO screen data here!
                
                framesCounter+=1
                
                if (framesCounter > 180) 
                then
                    screen = TITLE     -- Change to TITLE screen after 3 seconds
                    framesCounter = 0 
                end if
                
            break 
            case TITLE
            then
                -- Update TITLE screen data here!
                
                framesCounter+=1
                
                -- LESSON 03: Inputs management (keyboard, mouse)
                if (IsKeyPressed(KEY_ENTER)) 
                then 
                    screen = GAMEPLAY 
                    -- LESSON 07: Sounds and music loading and playing
                    PlaySound(fxStart)
                end if 

            break 
            
            case GAMEPLAY
            then
                -- Update GAMEPLAY screen data here!
                
                -- LESSON 03: Inputs management (keyboard, mouse)
                if (IsKeyPressed('P')) then gamePaused = not(gamePaused)    end if-- Pause button logic

                if not (gamePaused)
                then
                    -- Player movement logic
                    if (IsKeyDown(KEY_LEFT)) then player[p_position][x] -= player[p_speed][x] end if
                    if (IsKeyDown(KEY_RIGHT)) then player[p_position][x] += player[p_speed][x] end if
                    
                    if ((player[p_position][x]) <= 0) then player[p_position][x] = 0 end if
                    if ((player[p_position][x] + player[p_size][x]) >= screenWidth) 
                    then 
                        player[p_position][x] = screenWidth - player[p_size][x]
                    end if
                    
                    player[p_bounds] = { player[p_position][x], player[p_position][y], player[p_size][x], player[p_size][y] }

                    if (ball[b_active])
                    then
                        -- Ball movement logic
                        ball[b_position][x] += ball[b_speed][x]
                        ball[b_position][y] += ball[b_speed][y]
                        
                        -- Collision logic: ball vs screen-limits
                        if (((ball[b_position][x] + ball[b_radius]) >= screenWidth) or ((ball[p_position][x] - ball[b_radius]) <= 0)) 
                        then 
                            ball[b_speed][x] *= -1
                        end if
                        if ((ball[b_position][y] - ball[b_radius]) <= 0) 
                        then 
                            ball[b_speed][y] *= -1
                        end if
                        
                        -- LESSON 04: Collision detection and resolution
                        
                        -- NOTE: For collisions we consider elements bounds parameters, 
                        -- that's independent of elements drawing but they should match texture parameters
                        
                        -- Collision logic: ball vs player
                        if (CheckCollisionCircleRec(ball[b_position], ball[b_radius], player[p_bounds]))
                        then
                            ball[b_speed][y] *= -1
                            ball[b_speed][x] = (ball[b_position][x] - (player[p_position][x] + player[p_size][x]/2))/player[p_size][x]*5.0
                            -- LESSON 07: Sounds and music loading and playing
                            PlaySound(fxBounce)                     
                        end if
                        
                        -- Collision logic: ball vs bricks
                        for  j = 1 to BRICKS_LINES
                        do
                            for  i = 1 to  BRICKS_PER_LINE
                            do
                                if (bricks[j][i][br_active] and (CheckCollisionCircleRec(ball[b_position], ball[b_radius], bricks[j][i][br_bounds])))
                                then
                                    bricks[j][i][br_active] = false
                                    ball[b_speed][y] *= -1
                                    -- LESSON 07: Sounds and music loading and playing                                  
                                    PlaySound(fxExplode)
                                    break
                                end if
                            end for
                        end for

                        -- Game ending logic
                        if ((ball[b_position][y] + ball[b_radius]) >= screenHeight)
                        then
                            ball[b_position][x] = player[p_position][x] + player[p_size][x]/2
                            ball[b_position][y] = player[p_position][y] - ball[b_radius] - 1.0
                            ball[b_speed] = { 0, 0 }
                            ball[b_active] = false
                            player[p_lifes]-=1
                        end if
                        
                        if (player[p_lifes] < 0)
                        then
                            screen = ENDING
                            player[p_lifes] = 5
                            framesCounter = 0
                        end if
                    
                    else
                    
                        -- Reset ball position
                        ball[b_position][x] = player[p_position][x] + player[p_size][x]/2
                        
                        -- LESSON 03: Inputs management (keyboard, mouse)
                        if (IsKeyPressed(KEY_SPACE))
                        then
                            -- Activate ball logic
                            ball[b_active] = true
                            ball[b_speed] = { 0, -5.0 }
                        end if
                    end if
                end if

            break

            case ENDING 
            then
                -- Update END screen data here!
                
                framesCounter+=1
                
                -- LESSON 03: Inputs management (keyboard, mouse)
                if (IsKeyPressed(KEY_ENTER))
                then
                    -- Replay / Exit game logic
                    screen = TITLE
                    -- reset the game --> give back lifes reactivate bricks
                    player[p_lifes]=5
                for  j = 1 to BRICKS_LINES  
                do
                    for  i = 1  to BRICKS_PER_LINE  
                    do
                        bricks[j][i][br_active] = true 
                    end for
                end for
                end if
            break
            
            case else 
                break
        end switch

        -- LESSON 07: Sounds and music loading and playing
        -- NOTE: Music buffers must be refilled if consumed
        UpdateMusicStream(music)
        
        ------------------------------------------------------------------------------------
        
        -- Draw
        ------------------------------------------------------------------------------------
            BeginDrawing() 
        
            ClearBackground(RAYWHITE) 
            
            switch(screen) 
            do
                case LOGO
                then
                    -- Draw LOGO screen here!
                    
                    -- LESSON 05: Textures loading and drawing
                    DrawTexture(texLogo, screenWidth/2 - texLogo[tex_width]/2, screenHeight/2 - texLogo[tex_height]/2, WHITE)
                    
                break 
                case TITLE 
                then
                    -- Draw TITLE screen here!
                    
                    -- LESSON 06: Fonts loading and text drawing
                    DrawTextEx(font, "BLOCKS", { 100, 80 }, 160, 10, MAROON)     -- Draw Title
    
                    if (floor(mod((framesCounter/30),2)) = 0) 
                    then 
                        DrawText("PRESS [ENTER] to START", GetScreenWidth()/2 - MeasureText("PRESS [ENTER] to START", 20)/2, GetScreenHeight()/2 + 60, 20, DARKGRAY)
                    end if
                break 
                case GAMEPLAY
                then
                    -- Draw GAMEPLAY screen here!

                        -- LESSON 05: Textures loading and drawing
                        DrawTextureEx(texPaddle, player[p_position], 0.0, 1.0, WHITE)   -- Draw player
                        
                        DrawTexture(texBall, ball[b_position][x] - ball[b_radius]/2, ball[b_position][y] - ball[b_radius]/2, MAROON)    -- Draw ball
                    
                        -- Draw bricks
                        for j = 1 to BRICKS_LINES
                        do
                            for i = 1 to BRICKS_PER_LINE
                            do
                                if (bricks[j][i][br_active])
                                then
                                    -- NOTE: Texture is not scaled, just using original size
                                    
                                    if (floor(mod((i + j),2)) = 0) 
                                    then 
                                        DrawTextureEx(texBrick, bricks[j][i][br_position], 0.0, 1.0, GRAY)
                                    else 
                                        DrawTextureEx(texBrick, bricks[j][i][br_position], 0.0, 1.0, DARKGRAY)
                                    end if
                                end if
                            end for
                        end for
                    
                    
                    -- Draw GUI: player lives
                    for  i = 0 to player[p_lifes]   
                    do
                        DrawRectangle(20 + 40*i, screenHeight - 30, 35, 10, LIGHTGRAY) 
                    end for
                    -- Draw pause message when required
                    if (gamePaused) then 
                        DrawText("GAME PAUSED", screenWidth/2 - MeasureText("GAME PAUSED", 40)/2, screenHeight/2 + 60, 40, GRAY) 
                    end if
                break 
                case ENDING
                then
                    -- Draw END screen here!
                    
                    DrawText("ENDING SCREEN", 20, 20, 40, DARKBLUE) 
                    
                    if (floor(mod((framesCounter/30),2)) = 0) 
                    then 
                        DrawText("PRESS [ENTER] TO PLAY AGAIN", GetScreenWidth()/2 - MeasureText("PRESS [ENTER] TO PLAY AGAIN", 20)/2, GetScreenHeight()/2 + 80, 20, GRAY) 
                    end if
                break 
                case else break 
            end switch
        
        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    
    -- NOTE: Unload any loaded resources (texture, fonts, audio)
    -- LESSON 05: Textures loading and drawing
    UnloadTexture(texBall)
    UnloadTexture(texPaddle)
    UnloadTexture(texBrick)
    -- LESSON 07: Sounds and music loading and playing
    UnloadSound(fxStart)
    UnloadSound(fxBounce)
    UnloadSound(fxExplode)
    
    UnloadMusicStream(music)    -- Unload music streaming buffers
    
    CloseAudioDevice()      -- Close audio device connection    
    
    CloseWindow()           -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------
    

