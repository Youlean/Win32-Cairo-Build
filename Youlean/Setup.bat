
@set /p YCAIRO_MSVC_PATH=<Youlean\VS_Path.bat
@set /p X64_COMPILER=<Youlean\VS_Compiler.bat
@set /p MSVC_VERSION=<Youlean\VS_Version.bat

@set /p ENABLE_FREETYPE=<Youlean\Enable_Freetype.bat
@set /p BUILD_CONFIG=<Youlean\Build_Config.bat
@set /p BUILD_ARCH=<Youlean\Build_Arch.bat
@set /p MAKE_FLAGS=<Youlean\Make_Flags.bat

@echo.
@echo.
@echo  Welcome to Win32 Cairo Build Tool
@echo.
@echo     Made by Youlean (Feb.2016)
@echo.
@echo               V1.01
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause


@echo.
@echo.
@echo IMPORTANT!!! Read this!!!
@echo.
@echo Before building download the sources and place it in
@echo cairo, freetype, zlib, libpng and pixman folder.
@echo.
@echo From tools you will need msys(included), @fart.exe(included)
@echo Visual Studio 2013 or newer (but it could work on older VS too),
@echo and I am not sure, but you could need Windows SDK installed.

@echo.
@echo If your build fales, try again as it could sometimes break 
@echo because of parallel compilation...
@echo.
@echo After you see "Building..." don't exit CMD before it finish by
@echo it's self because then the script will not be able to do the 
@echo cleanup and the next build will probably fail.
@echo.
@echo If you exited CMD by accident, just delete all souces from
@echo cairo, freetype, zlib, libpng and pixman, and add fresh ones.
@echo.
@echo NOTE: If you exit CMD by clicking on "X" on window, it will 
@echo take few seconds before it closes, so wait a little bit... ;)
@echo.
@echo.
@pause


@rem Setting Visual Studio Path******************************************************************************

:vs_set_path
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo Would you like to setup Visual Studio compiler?
@echo.
@echo [you need to do this only once]
@echo.
@set /P ANSWER=(Y/N)
@echo.
@echo Your choice: "%ANSWER%"
@echo.
@if /i {%ANSWER%}=={Y} (@set SET_VS_PATH=TRUE) 
@if /i {%ANSWER%}=={N} (@set SET_VS_PATH=FALSE)   

@if /i not {%ANSWER%}=={Y} (
@if /i not {%ANSWER%}=={N} (
@echo Man, check your typing...
@echo.
@echo Let's go again...
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause
@goto vs_set_path
)
)



@rem If set path is true.....................................................................................

@if "%SET_VS_PATH%" == "FALSE" (@goto skip_setting_vs)

:vs_compiler 

@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo If you are running VS 2013 or 2012 Express version
@echo you need to choose "x86_amd64" as x64 compiler...
@echo. 
@echo If you are running VS 2013 or 2012 Pro, and 2015 Community
@echo [or better] version, you can use "x64" as x64 compiler...
@echo.
@echo [these are recommended settings]
@echo.
@echo Current compiler is [without quotes]: "%X64_COMPILER%"
@echo.
@set /P X64_ANSWER=(Type x86_amd64 or x64)
@echo.
@echo Your choice: "%X64_ANSWER%"
@echo.

@if /i not {%X64_ANSWER%}=={x86_amd64} (
@if /i not {%X64_ANSWER%}=={x64} (
@echo Man, check your typing...
@echo.
@echo Let's go again...
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause
@goto vs_compiler
)
)

@if /i {%X64_ANSWER%}=={x86_amd64} (
@tools\fart.exe -q -- "Youlean\VS_Compiler.bat" "%X64_COMPILER%" "x86_amd64"
) 
@if /i {%X64_ANSWER%}=={x64} (
@tools\fart.exe -q -- "Youlean\VS_Compiler.bat" "%X64_COMPILER%" "x64"
)   


:vs_version

@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo Checking what version of Visual Studio are you running...
@echo.
@echo For VS2013/VS2012 type "old", and for VS2015 or newer type "new"
@echo.
@echo Current version is [without quotes]: "%MSVC_VERSION%"
@echo.
@set /P VS_VERSION=(old/new)
@echo.
@echo Your choice: "%VS_VERSION%"
@echo.


@if /i not {%VS_VERSION%}=={old} (
@if /i not {%VS_VERSION%}=={new} (
@echo Man, check your typing...
@echo.
@echo Let's go again...
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause
@goto vs_version
)
)

@if /i {%VS_VERSION%}=={old} (
@tools\fart.exe -q -- "Youlean\VS_Version.bat" "%MSVC_VERSION%" "old"
) 
@if /i {%VS_VERSION%}=={new} (
@tools\fart.exe -q -- "Youlean\VS_Version.bat" "%MSVC_VERSION%" "new"
)   


:vs_false_path_goto

@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo Setting Visual Studio path...
@echo. 
@echo.
@echo You need something like [without quotes]
@echo.
@echo "C:\Program Files (x86)\Microsoft Visual Studio 14.0"
@echo.
@echo.
@echo Current path is [without quotes]: "%YCAIRO_MSVC_PATH%"
@echo.
@echo. 
@echo Enter path without quotes and backslash at the end!
@echo.
@set /P VS_ANSWER=(Enter path here)
@echo.
@echo Your choice: %VS_ANSWER% 
@echo.


@if not exist "%YCAIRO_MSVC_PATH%\VC\vcvarsall.bat" (
@echo.
@echo.
@echo INVALID VISUAL STUDIO PATH!!!
@echo.
@echo Lets try setting path again... 
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause
@goto vs_false_path_goto
)

@tools\fart.exe -q -- "Youlean\VS_Path.bat" "%YCAIRO_MSVC_PATH%" "%VS_ANSWER%"


@rem If you don't set VS, go here...
:skip_setting_vs

@echo.
@if not exist "%YCAIRO_MSVC_PATH%\VC\vcvarsall.bat" (
@echo.
@echo.
@echo INVALID VISUAL STUDIO PATH!!!
@echo.
@echo.
@echo Let's try setting Visual Studio path...
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause
@goto vs_false_path_goto
)

@rem Start Building*******************************************************************************************

@echo.
@echo LETS START BUILDING NOW!!!
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.


@rem Setting up input configuration***************************************************************************

:freetype_goto
@echo Would you like to build cairo with freetype support?
@set /P ANSWER=(Y/N)
@echo.
@echo Your choice: %ANSWER% 
@echo.

@if /i not {%ANSWER%}=={Y} (
@if /i not {%ANSWER%}=={N} (
@echo Man, check your typing...
@echo.
@echo Let's go again...
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause
@goto freetype_goto
)
)

@if /i {%ANSWER%}=={Y} (@tools\fart.exe -q -- "Youlean\Enable_Freetype.bat" "%ENABLE_FREETYPE%" "TRUE") 
@if /i {%ANSWER%}=={N} (@tools\fart.exe -q -- "Youlean\Enable_Freetype.bat" "%ENABLE_FREETYPE%" "FALSE")   


:config_goto
@echo What configuration would you like to build?
@set /P ANSWER=(Debug/Release)
@echo.
@echo Your choice: %ANSWER% 
@echo.

@if /i not {%ANSWER%}=={Debug} (
@if /i not {%ANSWER%}=={Release} (
@echo Man, check your typing...
@echo.
@echo Let's go again...
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause
@goto config_goto
)
)


@if /i {%ANSWER%}=={Debug} (@tools\fart.exe -q -- "Youlean\Build_Config.bat" "%BUILD_CONFIG%" "Debug") 
@if /i {%ANSWER%}=={Release} (@tools\fart.exe -q -- "Youlean\Build_Config.bat" "%BUILD_CONFIG%" "Release")


:arch_goto
@echo For what architecture would you like to build?
@set /P ARCH_ANSWER=(Win32/x64)
@echo.
@echo Your choice: %ARCH_ANSWER% 
@echo.


@if /i not {%ARCH_ANSWER%}=={Win32} (
@if /i not {%ARCH_ANSWER%}=={x64} (
@echo Man, check your typing...
@echo.
@echo Let's go again...
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause
@goto arch_goto
)
)


@if /i {%ARCH_ANSWER%}=={Win32} (@tools\fart.exe -q -- "Youlean\Build_Arch.bat" "%BUILD_ARCH%" "Win32") 
@if /i {%ARCH_ANSWER%}=={x64} (@tools\fart.exe -q -- "Youlean\Build_Arch.bat" "%BUILD_ARCH%" "x64")   


@if /i "%ARCH_ANSWER%" == "x64" (@goto skip_mmx)

:mmx_goto
@echo Do you want to enable MMX extension for Pixman and Cairo build?
@set /P ANSWER=(Y/N)
@echo.
@echo Your choice: %ANSWER% 
@echo.
@if /i {%ANSWER%}=={Y} (@set TMP_MAKE_FLAGS=MMX=on) 
@if /i {%ANSWER%}=={N} (@set TMP_MAKE_FLAGS=MMX=off)

@if /i not {%ANSWER%}=={Y} (
@if /i not {%ANSWER%}=={N} (
@echo Man, check your typing...
@echo.
@echo Let's go again...
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause
@goto mmx_goto
)
)

:skip_mmx
@echo.
@if /i "%ARCH_ANSWER%" == "x64" ( 
@set TMP_MAKE_FLAGS=MMX=off
@echo Unfortunately MMX does't work in x64 for Pixman and Cairo builds,
@echo so we need to disable it...
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause
)

:sse2_goto
@echo.
@echo Do you want to enable SSE2 extension for Pixman and Cairo build?
@set /P ANSWER=(Y/N)
@echo.
@echo Your choice: %ANSWER% 
@echo.
@if /i {%ANSWER%}=={Y} (@set TMP_MAKE_FLAGS=%TMP_MAKE_FLAGS% SSE2=on)
@if /i {%ANSWER%}=={N} (@set TMP_MAKE_FLAGS=%TMP_MAKE_FLAGS% SSE2=off)

@if /i not {%ANSWER%}=={Y} (
@if /i not {%ANSWER%}=={N} (
@echo Man, check your typing...
@echo.
@echo Let's go again...
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause
@goto sse2_goto
)
)

:ssse3_goto
@echo Do you want to enable SSSE3 extension for Pixman and Cairo build?
@set /P ANSWER=(Y/N)
@echo.
@echo Your choice: %ANSWER% 
@echo.
@if /i {%ANSWER%}=={Y} (@set TMP_MAKE_FLAGS=%TMP_MAKE_FLAGS% SSSE3=on)
@if /i {%ANSWER%}=={N} (@set TMP_MAKE_FLAGS=%TMP_MAKE_FLAGS% SSSE3=off)

@if /i not {%ANSWER%}=={Y} (
@if /i not {%ANSWER%}=={N} (
@echo Man, check your typing...
@echo.
@echo Let's go again...
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@pause
@goto ssse3_goto
)
)

@tools\fart.exe  -q -- "Youlean\Make_Flags.bat" "%MAKE_FLAGS%" "%TMP_MAKE_FLAGS%"

@echo.
@echo.
@echo Building...
@echo.
@echo.

@call Youlean\Build.bat
