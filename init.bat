@echo off
rem getting current dir name by Tamara Wijsman, https://superuser.com/questions/160702
for %%I in (.) do set CurrDirName=%%~nxI

SET "oldname=MyAwesomePlugin"

rename %oldname% %CurrDirName% 2>nul

rem recurse into subdirectories by Aacini, https://stackoverflow.com/questions/8397674
call :treeProcess
goto :finish

:treeProcess
rename %oldname%.* %CurrDirName%.* 2>nul
for %%f in (*) do (
if %%f NEQ init.bat (
rem search&replace by MC ND, https://stackoverflow.com/questions/23075953

    setlocal enableextensions disabledelayedexpansion
    echo %%f
    for /f "delims=" %%i in ('findstr /n "^" "%%f" ^& break ^> "%%f" ') do (
        set "line=%%i"
        setlocal enabledelayedexpansion
	   set lin2=!LINE:*:=!
	   if "!lin2!" NEQ "" (
	   >>"%%f" echo(!lin2:%oldname%=%CurrDirName%!
           ) else (
	   >>"%%f" echo.
           )
        endlocal
    )
)
)
for /D %%d in (*) do (
    cd %%d
    call :treeProcess
    cd ..
)
exit /b

:finish
rem delete .BAT file after completion by dbenham https://stackoverflow.com/questions/2888976/
(goto) 2>nul & git add -A & git rm -f "%~f0" & git commit -m "initialized"