@echo off & setlocal enabledelayedexpansion
cd %1
setlocal

for %%I in (.)  do (
    set dir_name=%%~nxI
)
if not %dir_name%==maps (
    echo "root name for compilation has to be called 'maps'"
    exit 1
)
if "%t6r_data%"=="" (
    echo "enviromental variable t6r_data does not exist"
    exit 1
)
if not exist %t6r_data% (
    echo "enviromental variable t6r_data does not point to directory"
    exit 1
)

set deploy_path=%t6r_data%\maps
set deploy_path=%deploy_path:/=\%

if exist %deploy_path% (
    rmdir /s/Q %deploy_path%
)
mkdir %deploy_path%
Xcopy /s/e . "%deploy_path%"
cd %deploy_path%

:compile
for %%F in (*.gsc) do (
    gscCompiler.exe %%F
    del /f %%F
    ren %%~nF-compiled.gsc %%~nF.gsc
)
for /D %%d in (*) do (
    cd %%d
    call :compile
    cd ..
)
endlocal