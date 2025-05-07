echo ON

cargo cinstall --library-type cdylib --release --prefix %LIBRARY_PREFIX%
if errorlevel 1 exit 1

:: rav1e includes a command line utility that cinstall will not install
cargo install --path . --root %LIBRARY_PREFIX%
if errorlevel 1 exit 1

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
if errorlevel 1 exit 1

:REM Remove binary since it takes alot of space and not really used downstream
:REM Can add later if people request as
:REM rav1e-bin
del /F /Q %LIBRARY_PREFIX%\bin\rav1e.exe
if errorlevel 1 exit 1

del /F /Q %LIBRARY_PREFIX%\.crates.toml
del /F /Q %LIBRARY_PREFIX%\.crates2.json
