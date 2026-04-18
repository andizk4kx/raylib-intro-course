# raylib Introduction Course ported to Phix/Euphoria

All lessons and examples in this repository have been ported so they can be used with Phix or Euphoria.
To run the lessons, you will need either [Euphoria](https://openeuphoria.org/) or [Phix](http://phix.x10.mx/) in their current 64-bit versions: [Euphoria 4.1](https://github.com/OpenEuphoria/euphoria) or [Phix 1.0.6](https://github.com/petelomax/Phix) 
The required wrapper (binding) is included here along with the lessons. This wrapper supports only Windows 64-bit.you can find the latest wrapper with over 50 examples for Raylib with Phix/Euphoria here:[wrapper](https://github.com/andizk4kx/raylib-playground)

# raylib Introduction Course

*by Ramon Santamaria ([@raysan5](https://github.com/raysan5))*

![blocks game](blocks_game.gif "Blocks Game")

## Introduction

In this introductory course to [raylib](http://www.raylib.com/) we will implement a Blocks game similar to the well-known [Arkanoid](https://en.wikipedia.org/wiki/Arkanoid) (Taito, 1986). Along this process we will learn how the videogames life cycle works, how to manage the window and player inputs, and how to draw some graphics on screen.

[raylib](http://www.raylib.com/) is a simple and easy-to-use library to enjoy videogames programming.

**Learning Outcomes:**

 - raylib functionality and possibilities
 - Videogame life cycle (Init -> Update -> Draw -> DeInit)
 - Basic screens management with screens transition
 - Basic shapes drawing (circle, rectangle)
 - Inputs management (keyboard, mouse)
 - Collision detection and resolution
 - Textures loading and drawing
 - Fonts loading and text drawing
 - Sounds and music loading and playing
 
**NOTE:** All code provided is in C language for simplicity and clearness but it's up to the student to use more complex C++ code structures (OOP) if desired.

## Lessons Summary

Lesson | Learning outcome | Source file | Related functions
:-----:|------------------|:------------|:-----------------:
[01](#lesson-01-introduction-to-raylib-and-videogames-programming) | raylib functionality, <br>videogame life cycle, <br>basic screens management | [01_blocks_game_intro.ex](lessons/01_blocks_game_intro.ex) | InitWindow(), CloseWindow(), <br>BeginDrawing(), EndDrawing()
[02](#lesson-02-draw-basic-shapes-circle-rectangle) | basic shapes drawing | [02_blocks_game_drawing.ex](lessons/02_blocks_game_drawing.ex) | DrawRectangle(), DrawCircle()
[03](#lesson-03-inputs-management-keyboard-mouse) | inputs management | [03_blocks_game_inputs.ex](lessons/03_blocks_game_inputs.ex) | IsKeyPressed(), IsKeyDown(), <br>IsMouseButtonPressed(), <br>IsMouseButtonDown(), <br>GetMouseX(), GetMouseY()
[04](#lesson-04-collision-detection-and-resolution) | collision detection and resolution | [04_blocks_game_collisions.ex](lessons/04_blocks_game_collisions.ex) | CheckCollisionCircleRec(), <br>CheckCollisionRecs(), <br>CheckCollisionCircles()
[05](#lesson-05-textures-loading-and-drawing) | textures loading and drawing | [05_blocks_game_textures.ex](lessons/05_blocks_game_textures.ex) | LoadTexture(), UnloadTexture(), <br>DrawTexture()
[06](#lesson-06-fonts-loading-and-text-drawing) | fonts loading and text drawing | [06_blocks_game_text.ex](lessons/06_blocks_game_text.ex) | LoadFont(), UnloadFont(), <br>DrawText(), DrawTextEx()
[07](#lesson-07-sounds-and-music-loading-and-playing) | sounds and music loading and playing | [07_blocks_game_audio.ex](lessons/07_blocks_game_audio.ex) | InitAudioDevice(), CloseAudioDevice(), <br>LoadSound(), UnloadSound(), <br>PlaySound(), LoadMusicStream(), UnloadMusicStream(), <br>PlayMusicStream()

**NOTE:** Most of the documentation for the exercise is directly included in the source code files as code comments. Read carefully those comments to understand every task and how implement the proposed solutions.

### Lesson 01: Introduction to raylib and videogames programming

*Lesson code file to review: [01_blocks_game_intro.ex](lessons/01_blocks_game_intro.ex)*

In this first lesson we will introduce raylib library and videogames programming principles. We will setup raylib and take a look to its functionality; we will see how videogame life cycle works and we will implement a basic screens management system for our game.

**Introduction to raylib**

raylib is simple and easy-to-use library to learn videogames programming. raylib abstracts the user from the more low level libraries like OpenGL or GLFW3.

Here there are some interesting links to know more about raylib:

 - [raylib Features](http://www.raylib.com)
 - [raylib Frequently Asked Questions](https://github.com/raysan5/raylib/blob/master/FAQ.md)
 - [raylib Architecture](https://github.com/raysan5/raylib/wiki/raylib-architecture)
 - [raylib Functions Cheatsheet](http://www.raylib.com/cheatsheet/cheatsheet.html)
 - [raylib Data Structures](https://github.com/raysan5/raylib/wiki/raylib-data-structures)
 - [raylib Examples](http://www.raylib.com/examples.html)
 - [raylib Wiki](https://github.com/raysan5/raylib/wiki)

raylib follows the KISS principle, providing simple functions with clear naming conventions. Main documentation for the library functionality is condensed in a single [cheatsheet](http://www.raylib.com/cheatsheet/cheatsheet.html).

**Environment setup**

raylib can be used with many environment configurations as far as a code-editor and compiler are provided.  
By default, [raylib webpage](http://www.raylib.com/) distributes a Windows Installer containing all required tools to develop videogames with raylib in C/C++ on Windows platforms. Tools included with installer are **preconfigured** versions of:

 - [w64devkit/MinGW](https://github.com/skeeto/w64devkit) - Minimalistic GNU for Windows, including GCC compiler and several tools and libraries
 - [Notepad++](https://notepad-plus-plus.org) - Windows simple code editor, preconfigured with multiple compiling scripts
 
In case some students desire to use other tools or want to work in another environment different than Windows, detailed information is provided on [raylib Wiki](https://github.com/raysan5/raylib/wiki) to configure raylib on multiple environments, including [macOS](https://github.com/raysan5/raylib/wiki/Working-on-macOS) and [GNU Linux](https://github.com/raysan5/raylib/wiki/Working-on-GNU-Linux) platforms.

**Basic concept: Game loop**

The standard videogame game loop or life-cycle consist of 4 parts: **Initialization -> [ Update -> Draw ] -> DeInitialization**

The following diagram shows this life-cycle, the related processes for every part of the cycle and some of the raylib functions involved in those processes:

![raylib Game Loop](images/raylib_game_loop_full.png)

**Basic concept: Graphic Pipeline**

Understanding the Graphics Pipeline is very important to understand the processes that happen in a computer to generate one-frame of the game. Despite it could be a quite advanced topic to go into detail, here it is a general diagram of the process:

![Graphics pipeline](images/graphics_pipeline.png)

**Basic concept: Screens management**

To manage the different screens for our game we have multiple options, we will start with the most simple one, based in game states tracked by a simple enum.

On our game loop (Update/Draw) we will just check for current game state and we will Update/Draw required data.

Recommended [raylib examples for Phix-Euphoria](https://github.com/andizk4kx/raylib-playground/tree/main/examples) to check:
 - [core_basic_window](https://github.com/andizk4kx/raylib-playground/blob/main/examples/core/core_basic_window.ex) - simple code showing a videogame life cycle
 - [core_basic_screen_manager](https://github.com/andizk4kx/raylib-playground/blob/main/examples/core/core_basic_screen_manager.ex) - basic screens management structure
 

### Lesson 02: Draw basic shapes (circle, rectangle)

*Lesson code file to review: [02_blocks_game_drawing.ex](lessons/02_blocks_game_drawing.ex)*

To draw basic shapes, raylib provides the following functions:
```Euphoria
procedure DrawPixel(integer posX, int posY, Color color);
procedure DrawLine(integer startPosX, integer startPosY, integer endPosX, integer endPosY, sequence color) -- color={r,g,b,a}
procedure DrawCircle(integer centerX, integer centerY, float radius, sequence color)
procedure DrawCircleLines(integer centerX, integer centerY, float radius, sequence color)
procedure DrawRectangle(integer posX, integer posY, integer width, integer height, sequence color)
procedure DrawRectangleLines(integer posX, integer posY, integer width, integer height, sequence color)
```
Most of those functions are self explanatory, they must be called in the draw part of the game loop, between `BeginDrawing()` and `EndDrawing()`. User needs to provide the drawing position (x, y), size and color. Just note that in case of rectangle-shapes drawing origin is upper-left corner while drawing circle-shapes origin is set in the center of the circle.

Recommended [raylib examples for Phix-Euphoria](https://github.com/andizk4kx/raylib-playground/tree/main/examples) to check:
 - [shapes_basic_shapes](https://github.com/andizk4kx/raylib-playground/blob/main/examples/shapes/shapes_basic_shapes.ex) - basic shapes drawing
 - [shapes_logo_raylib](https://github.com/andizk4kx/raylib-playground/blob/main/examples/shapes/shapes_logo_raylib.ex) - raylib logo drawn using shapes


### Lesson 03: Inputs management (keyboard, mouse)

*Lesson code file to review: [03_blocks_game_inputs.ex](lessons/03_blocks_game_inputs.ex)*

To manage inputs, raylib provides a set of functions to detect keyboard and mouse current state:
```Euphoria
function IsKeyPressed(integer key)               -- Detect if a key has been pressed once
function IsKeyDown(integer key)                  -- Detect if a key is being pressed
function IsKeyReleased(integer key)              -- Detect if a key has been released once
function IsKeyUp(integer key)                   -- Detect if a key is NOT being pressed
    
function IsMouseButtonPressed(integer button)    -- Detect if a mouse button has been pressed once
function IsMouseButtonDown(integer button)       -- Detect if a mouse button is being pressed
function IsMouseButtonReleased(integer button)   -- Detect if a mouse button has been released once
function IsMouseButtonUp(integer button)         -- Detect if a mouse button is NOT being pressed
function GetMouseX()                      -- Returns mouse position X
function GetMouseY()                    -- Returns mouse position Y
function GetMousePosition()           -- Returns mouse position XY as sequence {x,y}
```
This set of functions can be used in the `update` part of the game loop to check **if** one key or button has been pressed (or is being pressed in that frame).  

Recommended [raylib examples for Phix-Euphoria](https://github.com/andizk4kx/raylib-playground/tree/main/examples)  to check:
 - [core_input_keys](https://github.com/andizk4kx/raylib-playground/blob/main/examples/core/core_input_keys.ex) - keyboard inputs check
 - [core_input_mouse](https://github.com/andizk4kx/raylib-playground/blob/main/examples/core/core_input_mouse.ex) - mouse inputs check


### Lesson 04: Collision detection and resolution

*Lesson code file to review: [04_blocks_game_collisions.ex](lessons/04_blocks_game_collisions.ex)*

To check collisions between simple shapes (circle, rectangle), raylib provides the following functions:
```Euphoria
function CheckCollisionRecs(sequence rec1, sequence rec2)                                    -- Check collision between two rectangles rec={x,y,width,height}
function CheckCollisionCircles(sequence center1, atom radius1, sequence center2, atom radius2) -- Check collision between two circles center,radius={x,y}
function CheckCollisionCircleRec(sequence center, atom radius, sequence rec)                  -- Check collision between circle and rectangle
```
Those functions return *true* if the involved rectangles/circles collide, is up to the user to resolve that collision in an appropiate way. Keep always in mind that collisions in games are always treatened as two separate parts: **detection** and **resolution**.


### Lesson 05: Textures loading and drawing

*Lesson code file to review: [05_blocks_game_textures.ex](lessons/05_blocks_game_textures.ex)*

Actually texture loading and drawing is a quite complex process: 

First, the image file is loaded, image data is usually decompressed and decodified (.png, .jpg) to obtain a plain array of pixel data; every pixel can be interpreted with different pixel formats (8bit, 16bit, 32bit...) but usually raylib translates that data to RGBA 32Bit (4 channels - RedGrenBlueAlpha, 8bit per channel). Image data is loaded into RAM.

Second, that image data must be uploaded to VRAM memory (GPU) to be used on screen rendering. 

Third, when drawing a texture to screen, texture is actually pasted over a quad (two triangles structure) and processed to display on the screen; that processing occurs in a per-fragment basis... think about it like a per pixel or sub-pixel processing, placing every fragment on the final canvas.

raylib provides multiple functions to deal with textures an images, depending on the intended use of the data, user can choose the right one; for example, most of the time, images will be loaded as textures to be displayed on screen but image data can also be used to generate 3d models, like in the case of [heightmaps](https://www.raylib.com/examples/models/loader.html?name=models_heightmap).

To load and draw textures, raylib provides the following functions:
```Euphoria
function LoadTexture(sequence fileName);       -- Load an image file as texture into GPU memory
procedure UnloadTexture(sequence texture);             -- Unload texture from GPU memory

procedure DrawTexture(sequence texture, integer posX, integer posY, sequence tint); -- Draw a texture in the canvas
```

Recommended [raylib examples for Phix-Euphoria](https://github.com/andizk4kx/raylib-playground/tree/main/examples)  to check:
 - [textures_logo_raylib](https://github.com/andizk4kx/raylib-playground/blob/main/examples/textures/textures_logo_raylib.ex) - texture loading and drawing
 - [textures_rectangle](http://www.raylib.com/examples/textures/loader.html?name=textures_rectangle) - texture loading and piece drawing


### Lesson 06: Fonts loading and text drawing

*Lesson code file to review: [06_blocks_game_text.ex](lessons/06_blocks_game_text.ex)*

To draw text, raylib loads a default font on `InitWindow()`, that font is used when drawing text with:
```Euphoria
procedure DrawText(sequence text, integer posX, integer posY, integer fontSize, sequence color)
```
But raylib users can also load custom fonts, raylib support multiple fonts formats, including TTF format and BMFonts. To load custom fonts and draw with them, use the following functions:
```Euphoria
sequence LoadFont(sequence fileName)         -- Load a Font image into GPU 
procedure UnloadFont(sequence font)                  -- Unload Font from GPU memory

procedure DrawTextEx(sequence font,sequence text, sequence position, integer fontSize, integer spacing, sequence tint)
```

Recommended [raylib examples for Phix-Euphoria](https://github.com/andizk4kx/raylib-playground/tree/main/examples)  to check:
 - [text_sprite_fonts](https://github.com/andizk4kx/raylib-playground/blob/main/examples/text/text_font_spritefonts.ex) - sprite fonts loading and drawing
 - [text_bmfonts_ttf](https://github.com/andizk4kx/raylib-playground/blob/main/examples/text/text_font_loading.ex) - bmfonts and ttf fonts loading
 - [text_writing_anim](https://github.com/andizk4kx/raylib-playground/blob/main/examples/text/text_writing_anim.ex) - text writting animation effect


### Lesson 07: Sounds and music loading and playing

*Lesson code file to review: [07_blocks_game_audio.ex](lessons/07_blocks_game_audio.ex)*

To deal with audio on raylib, first of all, audio device must be initialized. To manage audio device, use the following functions:
```Euphoria
procedure InitAudioDevice(void)                -- Initialize audio device and context
procedure CloseAudioDevice(void)                -- Close the audio device and context (and music stream)
```
To load and play sounds, raylib provides the following functions:
```Euphoria
function LoadSound(sequence fileName)      -- Load sound from file into memory
procedure UnloadSound(sequence sound)              -- Unload sound from memory

procedure PlaySound(sequence sound)               -- Play a sound
procedure PauseSound(sequence sound)               -- Pause a sound
procedure ResumeSound(sequence sound)              -- Resume a paused sound
procedure StopSound(sequence sound)               -- Stop playing a sound
```
To load and stream music, raylib provides the following functions:
```Euphoria
function LoadMusicStream(sequence fileName)    -- Load music stream from file
procedure UnloadMusicStream(sequence music)            -- Unload music stream

procedure UpdateMusicStream(sequence music)            -- Update buffers for music streaming
procedure PlayMusicStream(sequence music)             -- Start music playing
procedure PauseMusicStream(sequence music)             -- Pause music playing
procedure ResumeMusicStream(sequence music)            -- Resume playing paused music
procedure StopMusicStream(sequence music)             -- Stop music playing
```

Recommended [raylib examples for Phix-Euphoria](https://github.com/andizk4kx/raylib-playground/tree/main/examples) to check:
 - [audio_sound_loading](https://github.com/andizk4kx/raylib-playground/blob/main/examples/audio/audio_sound_loading.ex) - sounds loading and playing
 - [audio_music_stream](https://github.com/andizk4kx/raylib-playground/blob/main/examples/audio/audio_music_stream.ex) - music loading and streaming


## Getting help 
It's recommended to join [raylib Discord community](https://discord.gg/raylib) to ask other developers and get help from the community or just showcase your creations.

## License

This lecture is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

Lessons code is licensed under an unmodified zlib/libpng license.

Check [LICENSE](LICENSE) for further details.

*Copyright (c) 2017-2022 Ramon Santamaria ([@raysan5](https://github.com/raysan5))*
