/*******************************************************************************************
*
*   PROJECT:        BLOCKS GAME
*   LESSON 01:      raylib intro
*   DESCRIPTION:    Introduction to raylib and the basic videogames life cycle
*
*  Execute with either
*
*  Euphoria eui filename.ex
*  or
*  Phix p64 filename.ex
*
*   Example originally created with raylib 2.0, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "raylib64.e"
--/*
integer true=1
integer false=0
--*/
------------------------------------------------------------------------------------
-- Types and Structures Definition
------------------------------------------------------------------------------------

-- LESSON 01: Window initialization and screens management
enum  LOGO, TITLE, GAMEPLAY, ENDING 

-- TODO: Define required structs

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

    -- Game required variables
    integer screen = LOGO       -- Current game screen state
    
    integer framesCounter = 0           -- General pourpose frames counter
    --integer gameResult = -1           -- Game result: 0 - Loose, 1 - Win, -1 - Not defined
    integer gamePaused = false      -- Game paused state toggle
    
    -- TODO: Define and Initialize game variables
        
    SetTargetFPS(60)                -- Set desired framerate (frames per second)
    ----------------------------------------------------------------------------------------
    
    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
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
                if ((IsKeyPressed(KEY_ENTER))or(IsKeyPressed(KEY_TAB))) then screen = GAMEPLAY end if 
                
            break 
            case GAMEPLAY
            then
                -- Update GAMEPLAY screen data here!

                if not(gamePaused)
                then
                    -- TODO: Gameplay logic
                end if
                
                if ((IsKeyPressed(KEY_ENTER))or(IsKeyPressed(KEY_TAB))) then screen = ENDING end if 

            break 
            case ENDING
            then
                -- Update END screen data here!
                
                framesCounter+=1 
                
                -- LESSON 03: Inputs management (keyboard, mouse)
                if ((IsKeyPressed(KEY_ENTER))or(IsKeyPressed(KEY_TAB))) then screen = TITLE end if

            break 
            case else 
            break 
        end switch
        ------------------------------------------------------------------------------------
        
        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 
        
            ClearBackground(RAYWHITE) 
            
            switch(screen) 
            do
                case LOGO
                then
                    -- TODO: Draw LOGO screen here!
                    DrawText("LOGO SCREEN", 20, 20, 40, LIGHTGRAY) 
                    DrawText("WAIT for 3 SECONDS...", 290, 220, 20, GRAY) 

                break 
                case TITLE
                then
                    -- TODO: Draw TITLE screen here!
                    DrawRectangle(0, 0, screenWidth, screenHeight, GREEN) 
                    DrawText("TITLE SCREEN", 20, 20, 40, DARKGREEN) 
                    DrawText("PRESS ENTER or TAB to JUMP to GAMEPLAY SCREEN", 120, 220, 20, DARKGREEN) 

                break 
                case GAMEPLAY
                then
                    -- TODO: Draw GAMEPLAY screen here!
                    DrawRectangle(0, 0, screenWidth, screenHeight, PURPLE) 
                    DrawText("GAMEPLAY SCREEN", 20, 20, 40, MAROON) 
                    DrawText("PRESS ENTER or TAB to JUMP to ENDING SCREEN", 130, 220, 20, MAROON) 

                break 
                case ENDING
                then
                    -- TODO: Draw ENDING screen here!
                    DrawRectangle(0, 0, screenWidth, screenHeight, BLUE) 
                    DrawText("ENDING SCREEN", 20, 20, 40, DARKBLUE) 
                    DrawText("PRESS ENTER or TAB to RETURN to TITLE SCREEN", 120, 220, 20, DARKBLUE) 

                break 
                case else 
                break 
            end switch
        
        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    
    -- NOTE: Unload any loaded resources (texture, fonts, audio)

    CloseWindow()               -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------

