@echo on

set outputDir=_master_image_template
call ..\..\..\..\framework\external\get_msbuild_path.bat


pushd ..\..

rmdir "%outputDir%\bonus\sonic3air_dev\scripts" /s /q
mkdir "%outputDir%\data"


:: Make sure the Release build is up-to-date
%msbuildPath% build\_vstudio\sonic3air.sln /property:Configuration=Release /property:Platform=x64 -verbosity:minimal

:: 2. Generar definiciones C++ (Espera dinámica a que termine el proceso)
start /wait "" "bin\Release_x64\Sonic3AIR.exe" -dumpcppdefinitions -nativize

:: 3. Empaquetar datos (Espera dinámica a que termine el proceso)
start /wait "" "bin\Release_x64\Sonic3AIR.exe" -pack

move "enginedata.bin" "%outputDir%\data"
move "gamedata.bin" "%outputDir%\data"
move "audiodata.bin" "%outputDir%\data"
move "audioremaster.bin" "%outputDir%\data"
copy "data\metadata.json" "%outputDir%\data" /y

:: Copy scripts
:: TODO: Make sure these scripts are really up-to-date
copy "saves\scripts.bin" "%outputDir%\data"

popd


:: Done
if "%1"=="" pause
