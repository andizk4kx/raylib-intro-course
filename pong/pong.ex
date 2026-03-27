/*******************************************************************************************
*
*   raylib pong
*
*   COMPILATION (Windows - MinGW):
*       gcc -o $(NAME_PART).exe $(FILE_NAME) -lraylib -lopengl32 -lgdi32 -lwinmm -Wall -std=c99
*
*   COMPILATION (Linux - GCC):
*       gcc -o $(NAME_PART).exe $(FILE_NAME) -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--/*
integer true=1
integer false=0
include std/math.e
--*/
enum  SCREEN_LOGO = 0, SCREEN_TITLE, SCREEN_GAMEPLAY, SCREEN_ENDING 
enum x=1,y=2
enum baseSize=1,texture=4
enum width=3,height=4 
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 600 

    --SetConfigFlags(FLAG_WINDOW_RESIZABLE | FLAG_WINDOW_UNDECORATED) 
    InitWindow(screenWidth, screenHeight, "raylib [core] example - basic window") 
    
    InitAudioDevice() 
    
    -- Ball
    sequence ballPosition = { screenWidth/2, screenHeight/2 } 
    atom ballRadius = 20.0
    integer ballSpeedX = 6 
    integer ballSpeedY = -4 
    
    -- Player
    sequence player = { 10, screenHeight/2 - 50, 25, 100 } 
    atom playerSpeed = 8.0
    integer playerScore = 0 

    -- Enemy
    sequence enemy = { screenWidth - 10 - 25, screenHeight/2 - 50, 25, 100 } 
    atom enemySpeed = 3.0
    integer enemyVisionRange = screenWidth/2 
    integer enemyScore = 0 
    
    -- Resources loading
    sequence texLogo = LoadTexture("resources/logo_raylib.png") 
    atom alphaLogo = 0.0
    integer logoState = 0           -- 0-FadeIn, 1-Wait, 2-FadeOut 
    
--  sequence imLogo = LoadImage("resources/logo_raylib.png") 
--  sequence texLogo = LoadTextureFromImage(imLogo) 
--  UnloadImage(imLogo) 
    
    --sequence fntTitle = LoadFont("resources/pixantiqua.ttf")      -- Font size: 32px default
    sequence fntTitle = LoadFontEx("resources/pixantiqua.ttf", 12, 0, 0)  -- Font size: pixel-perfect
    fntTitle[texture]=SetTextureFilter(fntTitle[texture], TEXTURE_FILTER_POINT) 
    
    sequence fxStart = LoadSound("resources/start.wav") 
    sequence fxPong = LoadSound("resources/pong.wav") 
    
    sequence ambient = LoadMusicStream("resources/qt-plimp.xm") 
    PlayMusicStream(ambient) 
    
    -- General variables
    integer pause = false 
    integer finishGame = false 
    integer framesCounter = 0 
    integer currentScreen = SCREEN_LOGO  -- 0-LOGO, 1-TITLE, 2-GAMEPLAY, 3-ENDING

    SetTargetFPS(60)            -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while (not WindowShouldClose() and not (finishGame))     -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        UpdateMusicStream(ambient) 
        
        switch (currentScreen)
        do
            case SCREEN_LOGO
            then
                if (logoState = 0)
                then
                    alphaLogo +=  (1.0/180) 
                    if (alphaLogo > 1.0)
                    then
                        alphaLogo = 1.0
                        logoState = 1 
                    end if
                
                elsif (logoState = 1)
                then
                    framesCounter+=1 
                    if (framesCounter >= 200)
                    then
                        framesCounter = 0 
                        logoState = 2 
                    end if
                
                elsif (logoState = 2)
                then
                    alphaLogo -=  (1.0/180) 
                    if (alphaLogo < 0.0)
                    then
                        alphaLogo = 0.0 
                        currentScreen = 1 
                    end if
                end if

             break 
            case SCREEN_TITLE
            then
                framesCounter+=1 
                
                -- Update TITLE screen
                if (IsKeyPressed(KEY_ENTER)) 
                then
                    PlaySound(fxStart) 
                    currentScreen = 2 
                end if
             break 
            case SCREEN_GAMEPLAY
            then
                -- Update GAMEPLAY screen
                if not (pause)
                then
                    -- Ball movement logic
                    ballPosition[x] += ballSpeedX 
                    ballPosition[y] += ballSpeedY 
                    
                    if (((ballPosition[x] + ballRadius) > screenWidth) or ((ballPosition[x] - ballRadius) < 0)) 
                    then
                        PlaySound(fxPong) 
                        ballSpeedX *= -1 
                    end if
                    
                    if (((ballPosition[y] + ballRadius) > screenHeight) or ((ballPosition[y] - ballRadius) < 0)) 
                    then
                        PlaySound(fxPong) 
                        ballSpeedY *= -1 
                    end if
                    
                    if ((ballPosition[x] - ballRadius) < 0) 
                    then 
                        enemyScore += 1000 
                    elsif ((ballPosition[x] + ballRadius) > GetScreenWidth()) then 
                        playerScore += 1000 
                    end if
                    
                    -- Player movement logic
                    if (IsKeyDown(KEY_UP)) 
                    then 
                        player[y] -= playerSpeed 
                    elsif (IsKeyDown(KEY_DOWN)) 
                    then 
                        player[y] += playerSpeed 
                    end if
                    
                    if (player[y] <= 0) 
                    then 
                        player[y] = 0 
                    elsif ((player[y] + player[height]) >= screenHeight) 
                    then 
                        player[y] = screenHeight - player[height] 
                    end if
                    
                    if (CheckCollisionCircleRec(ballPosition, ballRadius, player)) 
                    then
                        PlaySound(fxPong) 
                        ballSpeedX *= -1 
                    end if
                    
                    -- Enemy movement logic
                    if (ballPosition[x] > enemyVisionRange)
                    then
                        if (ballPosition[y] > (enemy[y] + enemy[height]/2)) 
                        then 
                            enemy[y] += enemySpeed 
                        elsif (ballPosition[y] < (enemy[y] + enemy[height]/2)) 
                        then 
                            enemy[y] -= enemySpeed 
                        end if
                    end if
                    
                    if (CheckCollisionCircleRec(ballPosition, ballRadius, enemy)) 
                    then
                        PlaySound(fxPong) 
                        ballSpeedX *= -1 
                    end if
                    
                    if (IsKeyDown(KEY_RIGHT)) 
                    then 
                        enemyVisionRange+=1 
                    elsif (IsKeyDown(KEY_LEFT)) 
                    then 
                        enemyVisionRange-=1
                    end if 
                end if
                
                if (IsKeyPressed(KEY_P)) then pause = not pause end if 
                
                if (IsKeyPressed(KEY_ENTER)) then currentScreen = 3 end if 
                break 
            case SCREEN_ENDING
            then
                -- Update ENDING screen
                if (IsKeyPressed(KEY_ENTER)) 
                then
                    --currentScreen = 1 
                    finishGame = true 
                end if
                break 
            case else 
            break 
        end switch
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 
            
            switch (currentScreen)
            do
                case SCREEN_LOGO
                then
                    -- Draw LOGO screen
                    --DrawRectangle(0, 0, screenWidth, screenHeight, BLUE) 
                    --DrawText("SCREEN LOGO", 10, 10, 30, DARKBLUE) 
                    
                    DrawTexture(texLogo, GetScreenWidth()/2 - texLogo[width]/2, GetScreenHeight()/2 - texLogo[height]/2 - 40, Fade(WHITE, alphaLogo)) 
                    break 
                case SCREEN_TITLE
                then
                    -- Draw TITLE screen
                    --DrawRectangle(0, 0, screenWidth, screenHeight, GREEN) 
                    --DrawText("SCREEN TITLE", 10, 10, 30, DARKGREEN) 
                    
                    DrawTextEx(fntTitle, "SUPER PONG", { 200, 100 }, fntTitle[baseSize]*6, 4, LIME) 
                    
                    if (mod((framesCounter/30),2)) 
                    then 
                        DrawText("PRESS ENTER to START", 200, 300, 30, BLACK) 
                    end if
                    
                    break 
                case SCREEN_GAMEPLAY
                then
                    DrawCircleV(ballPosition, ballRadius, RED) 

                    DrawRectangleRec(player, BLUE) 
                    
                    DrawRectangleRec(enemy, DARKGREEN) 
                    
                    DrawLine(enemyVisionRange, 0, enemyVisionRange, screenHeight, GRAY) 
                    
                    -- Draw hud
                    DrawText(TextFormat("%04d", playerScore), 100, 10, 30, BLUE) 
                    DrawText(TextFormat("%04d", enemyScore), screenWidth - 200, 10, 30, DARKGREEN) 
                    
                    if (pause)
                    then
                        DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), Fade(WHITE, 0.8)) 
                        DrawText("GAME PAUSED", 320, 200, 30, RED) 
                    end if
                    break 
                case SCREEN_ENDING
                then
                    -- Draw ENDING screen
                    DrawRectangle(0, 0, screenWidth, screenHeight, RED) 
                    DrawText("SCREEN ENDING", 10, 10, 30, MAROON) 
                    break 
                case else    
                    break 
            end switch

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadTexture(texLogo) 
    UnloadFont(fntTitle) 
    
    UnloadSound(fxStart) 
    UnloadSound(fxPong) 
    UnloadMusicStream(ambient) 
    
    CloseAudioDevice() 

    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


