@rem Print results to log file*******************************************************************************
@rem @goto Script_Start
@if exist "%~f0"_tmp.bat (del /q "%~f0"_tmp.bat)
@copy "%~f0" "%~f0"_tmp.bat
@tools\fart.exe -q -- "%~f0"_tmp.bat "@rem @goto Script_Start" "@goto Script_Start"
@call "%~f0"_tmp.bat 2>&1 | tools\msys\bin\tee.exe Build_Log.txt
@del /q "%~f0"_tmp.bat
@exit
@rem Print results to log file*******************************************************************************

:Script_Start
@echo.
@echo.
@echo  Welcome to Win32 Cairo Build Tool
@echo.
@echo     Made by Youlean (Feb.2016)
@echo.
@echo               V1.00
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
@echo This script by default uses Visual Studio 2015 with a path:
@echo C:\Program Files (x86)\Microsoft Visual Studio 14.0
@echo If you want to use different version of visual studio, or
@echo your visual studio path is different, open this .bat file with
@echo notepad and change path next to "@set YCAIRO_MSVC_PATH="
@echo.
@echo If your build fales, try again as it could sometimes break 
@echo because of parallel compilation...
@echo.
@echo When you see "Building..." don't exit CMD before it finish by
@echo it's self because then the script will not be able to do the 
@echo cleanup and the next build will probably fail.
@echo If you exited CMD by accident, just delete all souces from
@echo cairo, freetype, zlib, libpng and pixman, and add fresh ones.
@echo.
@pause






@set YCAIRO_MSVC_PATH=C:\Program Files (x86)\Microsoft Visual Studio 14.0






@echo.
@if not exist "%YCAIRO_MSVC_PATH%" (
@echo.
@echo.
@echo INVALID VISUAL STUDIO PATH!!!
@echo.
@echo.
@echo Open this .bat file and change path next to "@set YCAIRO_MSVC_PATH="
@echo.
@echo CMD is now exiting...
@echo.
@pause
@exit
)


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
@if /i {%ANSWER%}=={Y} (@set ENABLE_FREETYPE=TRUE) 
@if /i {%ANSWER%}=={N} (@set ENABLE_FREETYPE=FALSE)   

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

:config_goto
@echo What configuration would you like to build?
@set /P ANSWER=(Debug/Release)
@echo.
@echo Your choice: %ANSWER% 
@echo.
@if /i {%ANSWER%}=={Debug} (@set BUILD_CONFIG=Debug)
@if /i {%ANSWER%}=={Release} (@set BUILD_CONFIG=Release)

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

:arch_goto
@echo For what architecture would you like to build?
@set /P ANSWER=(Win32/x64)
@echo.
@echo Your choice: %ANSWER% 
@echo.
@if /i {%ANSWER%}=={Win32} (@set BUILD_ARCH=Win32) 
@if /i {%ANSWER%}=={x64} (@set BUILD_ARCH=x64)

@if /i not {%ANSWER%}=={Win32} (
@if /i not {%ANSWER%}=={x64} (
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

@if "%BUILD_ARCH%" == "x64" (@goto skip_mmx)

:mmx_goto
@echo Do you want to enable MMX extension for pixman and cairo build?
@set /P ANSWER=(Y/N)
@echo.
@echo Your choice: %ANSWER% 
@echo.
@if /i {%ANSWER%}=={Y} (@set MAKE_FLAGS=MMX=on) 
@if /i {%ANSWER%}=={N} (@set MAKE_FLAGS=MMX=off)

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
@if "%BUILD_ARCH%" == "x64" ( 
@set MAKE_FLAGS=MMX=off
@echo Unfortunately MMX does't work in x64
@echo so we need to skip it...
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
@echo Do you want to enable SSE2 extension for pixman and cairo build?
@set /P ANSWER=(Y/N)
@echo.
@echo Your choice: %ANSWER% 
@echo.
@if /i {%ANSWER%}=={Y} (@set MAKE_FLAGS=%MAKE_FLAGS% SSE2=on)
@if /i {%ANSWER%}=={N} (@set MAKE_FLAGS=%MAKE_FLAGS% SSE2=off)

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
@echo Do you want to enable SSSE3 extension for pixman and cairo build?
@set /P ANSWER=(Y/N)
@echo.
@echo Your choice: %ANSWER% 
@echo.
@if /i {%ANSWER%}=={Y} (@set MAKE_FLAGS=%MAKE_FLAGS% SSSE3=on)
@if /i {%ANSWER%}=={N} (@set MAKE_FLAGS=%MAKE_FLAGS% SSSE3=off)

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

@echo.
@echo.
@echo Building...
@echo.
@echo.



@rem Made by Youlean V1.0
@rem Begining
@rem *****************************************************************************************************

@rem Sets build configuration and flags

@if "%BUILD_CONFIG%" == "Debug" (@set MAKE_CONFIG=CFG=debug)
@if "%BUILD_CONFIG%" == "Release" (@set MAKE_CONFIG=CFG=release)
@if "%BUILD_ARCH%" == "Win32" (@set MAKE_ARCH=ARCH=x86)
@if "%BUILD_ARCH%" == "x64" (@set MAKE_ARCH=ARCH=x64)


@rem *****************************************************************************************************

@rem Setting paths... Use your paths corresponding to your instalation
@rem If I @remember correctly you need just Msys, and Visual Studio to compile everything
@rem If this doesnt work, than you need also Windows SDK

@set PATH=%PATH%;%cd%\tools\msys\bin;%cd%\tools;%YCAIRO_MSVC_PATH%\VC\bin;%YCAIRO_MSVC_PATH%\VC\bin\amd64;%windir%\System32\;

@rem *****************************************************************************************************

@rem Set build tools
@if "%BUILD_ARCH%" == "Win32" (call vcvars32.bat)
@if "%BUILD_ARCH%" == "x64" (call vcvars64.bat)


@rem *****************************************************************************************************

@rem Set current directory as root directory 
@set ROOTDIR=%cd%

@rem Delete old build*************************************************************************************
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%" (@del /q %ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%)
@rem Set build directories********************************************************************************
@if NOT exist "%ROOTDIR%\Build\Win32\Debug" (@mkdir %ROOTDIR%\Build\Win32\Debug)
@if NOT exist "%ROOTDIR%\Build\Win32\Release" (@mkdir %ROOTDIR%\Build\Win32\Release)
@if NOT exist "%ROOTDIR%\Build\x64\Debug" (@mkdir %ROOTDIR%\Build\x64\Debug)
@if NOT exist "%ROOTDIR%\Build\x64\Release" (@mkdir %ROOTDIR%\Build\x64\Release)

@if NOT exist "%ROOTDIR%\Build\Include\cairo" (@mkdir %ROOTDIR%\Build\Include\cairo)
@if NOT exist "%ROOTDIR%\Build\Include\freetype" (@mkdir %ROOTDIR%\Build\Include\freetype)
@if NOT exist "%ROOTDIR%\Build\Include\libpng" (@mkdir %ROOTDIR%\Build\Include\libpng)
@if NOT exist "%ROOTDIR%\Build\Include\pixman" (@mkdir %ROOTDIR%\Build\Include\pixman)
@if NOT exist "%ROOTDIR%\Build\Include\zlib" (@mkdir %ROOTDIR%\Build\Include\zlib)


@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************

@rem Build zlib*******************************************************************************************


@rem Copy project from libpng and upgrade project

@mkdir %ROOTDIR%\zlib\projects\visualc71
@copy "%ROOTDIR%\libpng\projects\visualc71\zlib.vcproj" "%ROOTDIR%\zlib\projects\visualc71"
@cd %ROOTDIR%\zlib\projects\visualc71

@rem Upgrade project
devenv zlib.vcproj /Upgrade

@rem Renames output from zlibd.lib into a zlib.lib
@if "%BUILD_CONFIG%" == "Debug" (@fart -- %ROOTDIR%\zlib\projects\visualc71\zlib.vcxproj "<OutputFile>$(OutDir)zlibd.lib</OutputFile>" "<OutputFile>$(OutDir)zlib.lib</OutputFile>")

@if "%BUILD_ARCH%" == "x64" (
@rem convert project to x64 
@fart -- %ROOTDIR%\zlib\projects\visualc71\zlib.vcxproj "<Platform>Win32</Platform>" "<Platform>x64</Platform>"
@fart -- %ROOTDIR%\zlib\projects\visualc71\zlib.vcxproj "LIB Debug|Win32" "LIB Debug|x64"
@fart -- %ROOTDIR%\zlib\projects\visualc71\zlib.vcxproj "LIB Release|Win32" "LIB Release|x64"
)

@rem Rename otput directory
@fart -- %ROOTDIR%\zlib\projects\visualc71\zlib.vcxproj "Win32_LIB_Release" "LIB_Release"
@fart -- %ROOTDIR%\zlib\projects\visualc71\zlib.vcxproj "Win32_LIB_Debug" "LIB_Debug"

@rem build zlib //you could add /p:Platform=x64 if it needs
@if "%BUILD_CONFIG%" == "Debug" (msbuild zlib.vcxproj /p:Configuration="LIB Debug" /p:Platform=%BUILD_ARCH% /maxcpucount:1)
@if "%BUILD_CONFIG%" == "Release" (msbuild zlib.vcxproj /p:Configuration="LIB Release" /p:Platform=%BUILD_ARCH% /maxcpucount:1)

@if "%BUILD_CONFIG%" == "Debug" (@cd LIB_Debug\ZLib)
@if "%BUILD_CONFIG%" == "Release" (@cd LIB_Release\ZLib)

@rem Checking if lib is x86 or x64: dumpbin  /headers zlib.lib | findstr machine

@rem Delete old build from zlib root dir
@if exist "%ROOTDIR%\zlib\zlib.lib" (@del /Q "%ROOTDIR%\zlib\zlib.lib")

@rem Copy new lib to zlib root dir
@if exist "%ROOTDIR%\zlib\zlib.lib" (@del /Q "%ROOTDIR%\zlib\zlib.lib")
@copy "zlib.lib" "%ROOTDIR%\zlib"

@rem delete old lib and copy zlib to output directory
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\zlib.lib" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\zlib.lib")

@if "%BUILD_CONFIG%" == "Debug" (@copy "zlib.lib" "%ROOTDIR%\Build\%BUILD_ARCH%\Debug")
@if "%BUILD_CONFIG%" == "Release" (@copy "zlib.lib" "%ROOTDIR%\Build\%BUILD_ARCH%\Release")


@rem Copy pdb file
@if "%BUILD_CONFIG%" == "Debug" (
@if not exist "%ROOTDIR%\cairo\src\debug" (@mkdir %ROOTDIR%\cairo\src\debug)
@copy "zlib.pdb" "%ROOTDIR%\cairo\src\debug"
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\zlib.pdb" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\zlib.pdb")
@copy "zlib.pdb" "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%"
)

@rem Go to build dir to fix delete error
@cd %ROOTDIR%

@rem delete old project file
@rd /S /Q %ROOTDIR%\zlib\projects

@rem copy headers
@cd %ROOTDIR%\zlib
@if exist "%ROOTDIR%\Build\Include\zlib\zlib.h" (@del /Q "%ROOTDIR%\Build\Include\zlib\zlib.h")
@copy "zlib.h" "%ROOTDIR%\Build\Include\zlib"
@if exist "%ROOTDIR%\Build\Include\zlib\zconf.h" (@del /Q "%ROOTDIR%\Build\Include\zlib\zconf.h")
@copy "zconf.h" "%ROOTDIR%\Build\Include\zlib"

@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************

@rem Build libpng*****************************************************************************************


@rem Backup old project files

@mkdir %ROOTDIR%\libpng\projects\visualc71-backup
@xcopy "%ROOTDIR%\libpng\projects\visualc71" "%ROOTDIR%\libpng\projects\visualc71-backup" /H /S /E
@cd %ROOTDIR%\libpng\projects\visualc71

@rem Upgrade project
devenv libpng.vcproj /Upgrade

@rem Renames output from libpngd.lib into a libpng.lib
@if "%BUILD_CONFIG%" == "Debug" (@fart -- %ROOTDIR%\libpng\projects\visualc71\libpng.vcxproj "<OutputFile>$(OutDir)libpngd.lib</OutputFile>" "<OutputFile>$(OutDir)libpng.lib</OutputFile>")


@rem zlib upgrade to x64**********************************************************************************
@rem Renames output from zlibd.lib into a zlib.lib
@if "%BUILD_CONFIG%" == "Debug" (@fart -- %ROOTDIR%\libpng\projects\visualc71\zlib.vcxproj "<OutputFile>$(OutDir)zlibd.lib</OutputFile>" "<OutputFile>$(OutDir)zlib.lib</OutputFile>")

@if "%BUILD_ARCH%" == "x64" (
@rem convert project to x64 
@fart -- %ROOTDIR%\libpng\projects\visualc71\zlib.vcxproj "<Platform>Win32</Platform>" "<Platform>x64</Platform>"
@fart -- %ROOTDIR%\libpng\projects\visualc71\zlib.vcxproj "LIB Debug|Win32" "LIB Debug|x64"
@fart -- %ROOTDIR%\libpng\projects\visualc71\zlib.vcxproj "LIB Release|Win32" "LIB Release|x64"
)

@rem Rename otput directory
@fart -- %ROOTDIR%\libpng\projects\visualc71\zlib.vcxproj "Win32_LIB_Release" "LIB_Release"
@fart -- %ROOTDIR%\libpng\projects\visualc71\zlib.vcxproj "Win32_LIB_Debug" "LIB_Debug"


@rem libpng upgrade to x64********************************************************************************
@if "%BUILD_ARCH%" == "x64" (
@rem convert project to x64 
@fart -- %ROOTDIR%\libpng\projects\visualc71\libpng.vcxproj "<Platform>Win32</Platform>" "<Platform>x64</Platform>"
@fart -- %ROOTDIR%\libpng\projects\visualc71\libpng.vcxproj "LIB Debug|Win32" "LIB Debug|x64"
@fart -- %ROOTDIR%\libpng\projects\visualc71\libpng.vcxproj "LIB Release|Win32" "LIB Release|x64"
)

@rem Rename otput directory
@fart -- %ROOTDIR%\libpng\projects\visualc71\libpng.vcxproj "Win32_LIB_Release" "LIB_Release"
@fart -- %ROOTDIR%\libpng\projects\visualc71\libpng.vcxproj "Win32_LIB_Debug" "LIB_Debug"

@rem build libpng 
@if "%BUILD_CONFIG%" == "Debug" (msbuild libpng.vcxproj /p:Configuration="LIB Debug" /p:Platform=%BUILD_ARCH% /maxcpucount:1)
@if "%BUILD_CONFIG%" == "Release" (msbuild libpng.vcxproj /p:Configuration="LIB Release" /p:Platform=%BUILD_ARCH% /maxcpucount:1)

@if "%BUILD_CONFIG%" == "Debug" (@cd LIB_Debug)
@if "%BUILD_CONFIG%" == "Release" (@cd LIB_Release)

@rem Checking if lib is x86 or x64: dumpbin  /headers libpng.lib | findstr machine

@rem Delete old build from libpng root dir
@if exist "%ROOTDIR%\libpng\libpng.lib" (@del /Q "%ROOTDIR%\libpng\libpng.lib")

@rem Copy new lib to libpng root dir
@if exist "%ROOTDIR%\libpng\libpng.lib" (@del /Q "%ROOTDIR%\libpng\libpng.lib")
@copy "libpng.lib" "%ROOTDIR%\libpng"

@rem delete old lib and copy libpng to output directory
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\libpng.lib" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\libpng.lib")

@if "%BUILD_CONFIG%" == "Debug" (@copy "libpng.lib" "%ROOTDIR%\Build\%BUILD_ARCH%\Debug")
@if "%BUILD_CONFIG%" == "Release" (@copy "libpng.lib" "%ROOTDIR%\Build\%BUILD_ARCH%\Release")

@rem Copy pdb file
@if "%BUILD_CONFIG%" == "Debug" (
@if not exist "%ROOTDIR%\cairo\src\debug" (@mkdir %ROOTDIR%\cairo\src\debug)
@copy "libpng.pdb" "%ROOTDIR%\cairo\src\debug"
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\libpng.pdb" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\libpng.pdb")
@copy "libpng.pdb" "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%"
)

@rem Go to build dir to fix delete error
@cd %ROOTDIR%

@rem Delete old project
@rd /S /Q %ROOTDIR%\libpng\projects\visualc71

@rem Restore old project files
@mkdir %ROOTDIR%\libpng\projects\visualc71
@xcopy "%ROOTDIR%\libpng\projects\visualc71-backup" "%ROOTDIR%\libpng\projects\visualc71" /H /S /E

@rem Delete backup
@rd /S /Q %ROOTDIR%\libpng\projects\visualc71-backup

@rem copy headers
@cd %ROOTDIR%\libpng
@if exist "%ROOTDIR%\Build\Include\libpng\png.h" (@del /Q "%ROOTDIR%\Build\Include\libpng\png.h")
@copy "png.h" "%ROOTDIR%\Build\Include\libpng"
@if exist "%ROOTDIR%\Build\Include\libpng\pngconf.h" (@del /Q "%ROOTDIR%\Build\Include\libpng\pngconf.h")
@copy "pngconf.h" "%ROOTDIR%\Build\Include\libpng"
@if exist "%ROOTDIR%\Build\Include\libpng\pnglibconf.h" (@del /Q "%ROOTDIR%\Build\Include\libpng\pnglibconf.h")
@copy "pnglibconf.h" "%ROOTDIR%\Build\Include\libpng"

@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************

@rem Build Freetype***************************************************************************************

@if "%ENABLE_FREETYPE%"=="FALSE" (@goto skip_freetype)

@rem Backup old project files

@mkdir %ROOTDIR%\freetype\builds\windows\vc2008-backup
@xcopy "%ROOTDIR%\freetype\builds\windows\vc2008" "%ROOTDIR%\freetype\builds\windows\vc2008-backup" /H /S /E
@cd %ROOTDIR%\freetype\builds\windows\vc2008

@rem Upgrade project
devenv freetype.vcproj /Upgrade

@if "%BUILD_ARCH%" == "x64" (
@rem convert project to x64 
@fart -- %ROOTDIR%\freetype\builds\windows\vc2008\freetype.vcxproj "<Platform>Win32</Platform>" "<Platform>x64</Platform>"
@fart -- %ROOTDIR%\freetype\builds\windows\vc2008\freetype.vcxproj "Debug Multithreaded|Win32" "Debug Multithreaded|x64"
@fart -- %ROOTDIR%\freetype\builds\windows\vc2008\freetype.vcxproj "Release Multithreaded|Win32" "Release Multithreaded|x64"
)

@rem Rename object directory
@fart -- %ROOTDIR%\freetype\builds\windows\vc2008\freetype.vcxproj ".\..\..\..\objs\release_mt" "LIB_Release"
@fart -- %ROOTDIR%\freetype\builds\windows\vc2008\freetype.vcxproj ".\..\..\..\objs\debug_mt" "LIB_Debug"

@rem Rename output directory
@fart -- %ROOTDIR%\freetype\builds\windows\vc2008\freetype.vcxproj "<OutputFile>..\..\..\objs\win32\vc2008\freetype262MT.lib</OutputFile>" "<OutputFile>LIB_Release\freetype.lib</OutputFile>"
@fart -- %ROOTDIR%\freetype\builds\windows\vc2008\freetype.vcxproj "<OutputFile>..\..\..\objs\win32\vc2008\freetype262MT_D.lib</OutputFile>" "<OutputFile>LIB_Debug\freetype.lib</OutputFile>"


@rem build freetype
@if "%BUILD_CONFIG%" == "Debug" (msbuild freetype.vcxproj /p:Configuration="Debug Multithreaded" /p:Platform=%BUILD_ARCH% /maxcpucount:1)
@if "%BUILD_CONFIG%" == "Release" (msbuild freetype.vcxproj /p:Configuration="Release Multithreaded" /p:Platform=%BUILD_ARCH% /maxcpucount:1)


@if "%BUILD_CONFIG%" == "Debug" (@cd LIB_Debug)
@if "%BUILD_CONFIG%" == "Release" (@cd LIB_Release)

@rem Delete old build from freetype root dir
@if exist "%ROOTDIR%\freetype\freetype.lib" (@del /Q "%ROOTDIR%\freetype\freetype.lib")

@rem Copy new lib to freetype root dir
@copy "freetype.lib" "%ROOTDIR%\freetype"

@rem delete old lib and copy freetype to output directory
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\freetype.lib" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\freetype.lib")

@if "%BUILD_CONFIG%" == "Debug" (@copy "freetype.lib" "%ROOTDIR%\Build\%BUILD_ARCH%\Debug")
@if "%BUILD_CONFIG%" == "Release" (@copy "freetype.lib" "%ROOTDIR%\Build\%BUILD_ARCH%\Release")


@rem Copy debug file for freetype
@if "%BUILD_CONFIG%" == "Debug" (
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\freetype.pdb" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\freetype.pdb")
@copy "freetype.pdb" "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%"
@if not exist "%ROOTDIR%\cairo\src\debug" (@mkdir %ROOTDIR%\cairo\src\debug)
@copy "freetype.pdb" "%ROOTDIR%\cairo\src\debug"
)

@if "%BUILD_CONFIG%" == "Debug" (@copy "freetype.pdb" "%ROOTDIR%\Build\%BUILD_ARCH%\Debug")
@if "%BUILD_CONFIG%" == "Release" (@copy "freetype.pdb" "%ROOTDIR%\Build\%BUILD_ARCH%\Release")
)

@rem Go to build dir to fix delete error
@cd %ROOTDIR%

@rem Delete old project
@rd /S /Q %ROOTDIR%\freetype\builds\windows\vc2008

@rem Restore old project files
@mkdir %ROOTDIR%\freetype\builds\windows\vc2008
@xcopy "%ROOTDIR%\freetype\builds\windows\vc2008-backup" "%ROOTDIR%\freetype\builds\windows\vc2008" /H /S /E

@rem Delete backup
@rd /S /Q %ROOTDIR%\freetype\builds\windows\vc2008-backup

@rem Copy headers
@if exist "%ROOTDIR%\Build\Include\freetype" (@rd /S /Q %ROOTDIR%\Build\Include\freetype)
@xcopy "%ROOTDIR%\freetype\include\freetype\" "%ROOTDIR%\Build\Include\freetype" /H /S /E
@if exist "%ROOTDIR%\Build\Include\ft2build.h" (@del /Q "%ROOTDIR%\Build\Include\ft2build.h")
@copy "%ROOTDIR%\freetype\include\ft2build.h" "%ROOTDIR%\Build\Include"

:skip_freetype
@if "%ENABLE_FREETYPE%"=="FALSE" (
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\freetype.lib" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\freetype.lib")
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\freetype.pdb" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\freetype.pdb")
@if exist "%ROOTDIR%\Build\Include\freetype" (@rd /S /Q %ROOTDIR%\Build\Include\freetype)
@if exist "%ROOTDIR%\Build\Include\ft2build.h" (@del /Q "%ROOTDIR%\Build\Include\ft2build.h")
)
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************

@rem Build Pixman*****************************************************************************************


@cd %ROOTDIR%\pixman\pixman

@rem Use @fart to rename MD to MT to get static build
@fart -- %ROOTDIR%\pixman\Makefile.win32.common -MD -MT

@rem Build
make -j1 -k -f Makefile.win32 %MAKE_CONFIG% %MAKE_ARCH% %MAKE_FLAGS%


@rem Copy lib to build folder and make sure to delete previous build
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\pixman-1.lib" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\pixman-1.lib")

@rem copy pixman to output directory
@if "%BUILD_CONFIG%" == "Debug" (@copy "%ROOTDIR%\pixman\pixman\debug\pixman-1.lib" "%ROOTDIR%\Build\%BUILD_ARCH%\Debug")
@if "%BUILD_CONFIG%" == "Release" (@copy "%ROOTDIR%\pixman\pixman\release\pixman-1.lib" "%ROOTDIR%\Build\%BUILD_ARCH%\Release") 


@rem Copy headers
@if exist "%ROOTDIR%\Build\Include\pixman\pixman.h" (@del /Q "%ROOTDIR%\Build\Include\pixman\pixman.h")
@copy "%ROOTDIR%\pixman\pixman\pixman.h" "%ROOTDIR%\Build\Include\pixman"
@if exist "%ROOTDIR%\Build\Include\pixman\pixman-version.h" (@del /Q "%ROOTDIR%\Build\Include\pixman\pixman-version.h")
@copy "%ROOTDIR%\pixman\pixman\pixman-version.h" "%ROOTDIR%\Build\Include\pixman"

@rem You can check if Visual Studio compiles 64bit lib with command: dumpbin /headers pixman-1.lib | findstr machine, just change directory to pixman-1.lib before using it

@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************

@rem Build Cairo******************************************************************************************

@rem If freetype is enabled edit cairo source to enable it
@if "%ENABLE_FREETYPE%"=="TRUE" (
@mkdir %ROOTDIR%\cairo\build\config_backup
@copy "%ROOTDIR%\cairo\build\Makefile.win32.features" "%ROOTDIR%\cairo\build\config_backup"
@copy "%ROOTDIR%\cairo\build\Makefile.win32.common" "%ROOTDIR%\cairo\build\config_backup"
@fart -- %ROOTDIR%\cairo\build\Makefile.win32.features "CAIRO_HAS_FT_FONT=0" "CAIRO_HAS_FT_FONT=1"
@fart -- %ROOTDIR%\cairo\build\Makefile.win32.common "CAIRO_LIBS =  gdi32.lib msimg32.lib user32.lib" "CAIRO_LIBS =  gdi32.lib msimg32.lib user32.lib $(LIBPNG_PATH)/../freetype/freetype.lib"
)


@set INCLUDE=%INCLUDE%;%ROOTDIR%\zlib
@set INCLUDE=%INCLUDE%;%ROOTDIR%\libpng
@set INCLUDE=%INCLUDE%;%ROOTDIR%\pixman\pixman
@set INCLUDE=%INCLUDE%;%ROOTDIR%\freetype\include
@set INCLUDE=%INCLUDE%;%ROOTDIR%\cairo\boilerplate
@set INCLUDE=%INCLUDE%;%ROOTDIR%\cairo\src

@set LIB=%LIB%;%ROOTDIR%\zlib\
@set LIB=%LIB%;%ROOTDIR%\libpng\
@set LIB=%LIB%;%ROOTDIR%\pixman\


@cd %ROOTDIR%\cairo

@rem Use @fart to rename MD to MT to get static build
@fart -- %ROOTDIR%\cairo\build\Makefile.win32.common -MD -MT

@rem Use static build of zlib
@fart -- %ROOTDIR%\cairo\build\Makefile.win32.common zdll.lib zlib.lib


@rem Build
make -j1 -k -f Makefile.win32 %MAKE_CONFIG% %MAKE_ARCH% %MAKE_FLAGS% 


@rem dumpbin  /headers cairo-ft-font.obj | findstr machine

@rem Restore edited source files
@if "%ENABLE_FREETYPE%"=="TRUE" (
@if exist "%ROOTDIR%\cairo\build\Makefile.win32.features" (@del /Q "%ROOTDIR%\cairo\build\Makefile.win32.features")
@if exist "%ROOTDIR%\cairo\build\Makefile.win32.common" (@del /Q "%ROOTDIR%\cairo\build\Makefile.win32.common")
@copy "%ROOTDIR%\cairo\build\config_backup\Makefile.win32.features" "%ROOTDIR%\cairo\build"
@copy "%ROOTDIR%\cairo\build\config_backup\Makefile.win32.common" "%ROOTDIR%\cairo\build"
@rd /S /Q %ROOTDIR%\cairo\build\config_backup
)


@rem Copy cairo.lib to build folder and make sure to delete previous build
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\cairo.lib" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\cairo.lib")

@rem copy cairo to output directory
@if "%BUILD_CONFIG%" == "Debug" (@copy "%ROOTDIR%\cairo\src\debug\cairo.lib" "%ROOTDIR%\Build\%BUILD_ARCH%\Debug")
@if "%BUILD_CONFIG%" == "Release" (@copy "%ROOTDIR%\cairo\src\release\cairo.lib" "%ROOTDIR%\Build\%BUILD_ARCH%\Release")


@rem Copy cairo.dll to build folder and make sure to delete previous build
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\cairo.dll" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\cairo.dll")

@rem copy cairo to output directory
@if "%BUILD_CONFIG%" == "Debug" (@copy "%ROOTDIR%\cairo\src\debug\cairo.dll" "%ROOTDIR%\Build\%BUILD_ARCH%\Debug")
@if "%BUILD_CONFIG%" == "Release" (@copy "%ROOTDIR%\cairo\src\release\cairo.dll" "%ROOTDIR%\Build\%BUILD_ARCH%\Release")


@rem Copy cairo-static.lib to build folder and make sure to delete previous build
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\cairo-static.lib" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\cairo-static.lib")

@rem copy cairo to output directory
@if "%BUILD_CONFIG%" == "Debug" (@copy "%ROOTDIR%\cairo\src\debug\cairo-static.lib" "%ROOTDIR%\Build\%BUILD_ARCH%\Debug")
@if "%BUILD_CONFIG%" == "Release" (@copy "%ROOTDIR%\cairo\src\release\cairo-static.lib" "%ROOTDIR%\Build\%BUILD_ARCH%\Release")

@rem Copy pdb file
@if "%BUILD_CONFIG%" == "Debug" (
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\cairo.pdb" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\cairo.pdb")
@copy "%ROOTDIR%\cairo\src\debug\cairo.pdb" "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%"
)

@rem Go to build dir to fix delete error
@cd %ROOTDIR%

@rem Delete cairo old builds
@if "%BUILD_CONFIG%" == "Debug" (@rd /S /Q %ROOTDIR%\cairo\src\debug)
@if "%BUILD_CONFIG%" == "Release" (@rd /S /Q %ROOTDIR%\cairo\src\release)


@rem Copy headers
@if exist "%ROOTDIR%\Build\Include\cairo\cairo.h" (@del /Q "%ROOTDIR%\Build\Include\cairo\cairo.h")
@copy "%ROOTDIR%\cairo\src\cairo.h" "%ROOTDIR%\Build\Include\cairo"
@if exist "%ROOTDIR%\Build\Include\cairo\cairo-deprecated.h" (@del /Q "%ROOTDIR%\Build\Include\cairo\cairo-deprecated.h")
@copy "%ROOTDIR%\cairo\src\cairo-deprecated.h" "%ROOTDIR%\Build\Include\cairo"
@if exist "%ROOTDIR%\Build\Include\cairo\cairo-features.h" (@del /Q "%ROOTDIR%\Build\Include\cairo\cairo-features.h")
@copy "%ROOTDIR%\cairo\src\cairo-features.h" "%ROOTDIR%\Build\Include\cairo"
@if exist "%ROOTDIR%\Build\Include\cairo\cairo-pdf.h" (@del /Q "%ROOTDIR%\Build\Include\cairo\cairo-pdf.h")
@copy "%ROOTDIR%\cairo\src\cairo-pdf.h" "%ROOTDIR%\Build\Include\cairo"
@if exist "%ROOTDIR%\Build\Include\cairo\cairo-ps.h" (@del /Q "%ROOTDIR%\Build\Include\cairo\cairo-ps.h")
@copy "%ROOTDIR%\cairo\src\cairo-ps.h" "%ROOTDIR%\Build\Include\cairo"
@if exist "%ROOTDIR%\Build\Include\cairo\cairo-script.h" (@del /Q "%ROOTDIR%\Build\Include\cairo\cairo-script.h")
@copy "%ROOTDIR%\cairo\src\cairo-script.h" "%ROOTDIR%\Build\Include\cairo"
@if exist "%ROOTDIR%\Build\Include\cairo\cairo-svg.h" (@del /Q "%ROOTDIR%\Build\Include\cairo\cairo-svg.h")
@copy "%ROOTDIR%\cairo\src\cairo-svg.h" "%ROOTDIR%\Build\Include\cairo"
@if exist "%ROOTDIR%\Build\Include\cairo\cairo-version.h" (@del /Q "%ROOTDIR%\Build\Include\cairo\cairo-version.h")
@copy "%ROOTDIR%\cairo\cairo-version.h" "%ROOTDIR%\Build\Include\cairo"
@if exist "%ROOTDIR%\Build\Include\cairo\cairo-win32.h" (@del /Q "%ROOTDIR%\Build\Include\cairo\cairo-win32.h")
@copy "%ROOTDIR%\cairo\src\cairo-win32.h" "%ROOTDIR%\Build\Include\cairo"

@if "%ENABLE_FREETYPE%"=="TRUE" (
@if exist "%ROOTDIR%\Build\Include\cairo\cairo-ft.h" (@del /Q "%ROOTDIR%\Build\Include\cairo\cairo-ft.h")
@copy "%ROOTDIR%\cairo\src\cairo-ft.h" "%ROOTDIR%\Build\Include\cairo"
)

@rem Remove old Cairo features
@if exist "%ROOTDIR%\cairo\src\cairo-features.h" (@del /Q "%ROOTDIR%\cairo\src\cairo-features.h")


@rem Clean the pixman build*******************************************************************************

@rem Go to build dir to fix delete error
@cd %ROOTDIR%

@rem Delete old builds
@if "%BUILD_CONFIG%" == "Debug" (@rd /S /Q %ROOTDIR%\pixman\pixman\debug)
@if "%BUILD_CONFIG%" == "Release" (@rd /S /Q %ROOTDIR%\pixman\pixman\release)

@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************
@rem *****************************************************************************************************

@rem Add txt file with description of what was built
@if exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\Build_Info.txt" (@del /Q "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\Build_Info.txt")
@echo Configuration: "%BUILD_CONFIG%|%BUILD_ARCH%" > %ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\Build_Info.txt
@echo Cairo and Pixman extensions: "%MAKE_FLAGS%" >> %ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\Build_Info.txt
@echo Made by Youlean >> %ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\Build_Info.txt


@rem Check if everythig was built sucessuly***************************************************************
@if not exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\zlib.lib" (
@echo.
@echo.
@echo.
@echo.
@echo SHIT!!! Something went wrong...
@echo.
@echo Read text at beginning, it might help you...
@echo If you still can not make it work, throw your PC in the garbage
@echo and go fishing...
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
@exit
)

@if "%BUILD_CONFIG%" == "Debug" (
@if not exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\zlib.pdb" (
@echo.
@echo.
@echo.
@echo.
@echo SHIT!!! Something went wrong...
@echo.
@echo Read text at beginning, it might help you...
@echo If you still can not make it work, throw your PC in the garbage
@echo and go fishing...
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
@exit
)
)

@if not exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\libpng.lib" (
@echo.
@echo.
@echo.
@echo.
@echo SHIT!!! Something went wrong...
@echo.
@echo Read text at beginning, it might help you...
@echo If you still can not make it work, throw your PC in the garbage
@echo and go fishing...
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
@exit
)

@if "%BUILD_CONFIG%" == "Debug" (
@if not exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\libpng.pdb" (
@echo.
@echo.
@echo.
@echo.
@echo SHIT!!! Something went wrong...
@echo.
@echo Read text at beginning, it might help you...
@echo If you still can not make it work, throw your PC in the garbage
@echo and go fishing...
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
@exit
)
)

@if not exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\pixman-1.lib" (
@echo.
@echo.
@echo.
@echo.
@echo SHIT!!! Something went wrong...
@echo.
@echo Read text at beginning, it might help you...
@echo If you still can not make it work, throw your PC in the garbage
@echo and go fishing...
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
@exit
)

@if "%ENABLE_FREETYPE%"=="TRUE" (
@if not exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\freetype.lib" (
@echo.
@echo.
@echo.
@echo.
@echo SHIT!!! Something went wrong...
@echo.
@echo Read text at beginning, it might help you...
@echo If you still can not make it work, throw your PC in the garbage
@echo and go fishing...
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
@exit
)

@if "%BUILD_CONFIG%" == "Debug" (
@if not exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\freetype.pdb" (
@echo.
@echo.
@echo.
@echo.
@echo SHIT!!! Something went wrong...
@echo.
@echo Read text at beginning, it might help you...
@echo If you still can not make it work, throw your PC in the garbage
@echo and go fishing...
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
@exit
)
)
)

@if not exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\cairo.lib" (
@echo.
@echo.
@echo.
@echo.
@echo SHIT!!! Something went wrong...
@echo.
@echo Read text at beginning, it might help you...
@echo If you still can not make it work, throw your PC in the garbage
@echo and go fishing...
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
@exit
)

@if not exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\cairo-static.lib" (
@echo.
@echo.
@echo.
@echo.
@echo SHIT!!! Something went wrong...
@echo.
@echo Read text at beginning, it might help you...
@echo If you still can not make it work, throw your PC in the garbage
@echo and go fishing...
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
@exit
)

@if not exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\cairo.dll" (
@echo.
@echo.
@echo.
@echo.
@echo SHIT!!! Something went wrong...
@echo.
@echo Read text at beginning, it might help you...
@echo If you still can not make it work, throw your PC in the garbage
@echo and go fishing...
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
@exit
)

@if "%BUILD_CONFIG%" == "Debug" (
@if not exist "%ROOTDIR%\Build\%BUILD_ARCH%\%BUILD_CONFIG%\cairo.pdb" (
@echo.
@echo.
@echo.
@echo.
@echo SHIT!!! Something went wrong...
@echo.
@echo Read text at beginning, it might help you...
@echo If you still can not make it work, throw your PC in the garbage
@echo and go fishing...
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
@exit
)
)

@echo.
@echo.
@echo.
@echo.
@echo You're the man!!!
@echo.
@echo Everything went just fine, 
@echo but this doesn't mean that it wont break next time you try... :P
@echo Enjoy until next build...
@echo.
@echo.
@echo.
@echo Regards, Youlean
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
@exit