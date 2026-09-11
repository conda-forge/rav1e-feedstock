@echo on
call %CC% /nologo /MD /I"%LIBRARY_INC%\rav1e" encode-test.c /link /LIBPATH:"%LIBRARY_LIB%" rav1e.dll.lib /OUT:encode-test.exe
if errorlevel 1 exit /b 1
encode-test.exe
if errorlevel 1 exit /b 1
dumpbin /headers "%LIBRARY_BIN%\rav1e.dll" | findstr /I /C:"AA64 machine (ARM64)"
if errorlevel 1 exit /b 1
dumpbin /headers encode-test.exe | findstr /I /C:"AA64 machine (ARM64)"
if errorlevel 1 exit /b 1
