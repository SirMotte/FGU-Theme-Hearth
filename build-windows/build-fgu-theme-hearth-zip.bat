:: Works on Windows (10 and 11, at least). Assumes running from Theme_SirMotte_Hearth\build
:: Use GitHub Action 'Create Release' for official release builds but this helps during development.
mkdir out\Theme_SirMotte_Hearth
copy ..\extension.xml out\Theme_SirMotte_Hearth\
copy ..\SirMotte_footface.png out\Theme_SirMotte_Hearth\
xcopy ..\common\*.* out\Theme_SirMotte_Hearth\common /h /i /c /k /e /r /y
xcopy ..\graphics\*.* out\Theme_SirMotte_Hearth\graphics /h /i /c /k /e /r /y
xcopy ..\rulesets\*.* out\Theme_SirMotte_Hearth\rulesets /h /i /c /k /e /r /y
xcopy ..\scripts\*.* out\Theme_SirMotte_Hearth\scripts /h /i /c /k /e /r /y
cd out
CALL ..\zip-items Theme_SirMotte_Hearth
rmdir /S /Q Theme_SirMotte_Hearth\
copy Theme_SirMotte_Hearth.zip Theme_SirMotte_Hearth.ext
cd ..
explorer .\out
