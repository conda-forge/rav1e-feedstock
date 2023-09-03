echo ON

cargo cinstall --library-type cdylib --release --prefix %LIBRARY_PREFIX%
if errorlevel 1 exit 1

:: rav1e includes a command line utility that cinstall will not install
cargo install --path . --root %LIBRARY_PREFIX%
if errorlevel 1 exit 1

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
if errorlevel 1 exit 1