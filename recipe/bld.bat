echo ON

:: cargo-c is a rust build tool that generates shared library and pkgconfig
:: it is installed into the build prefix
:: https://github.com/xiph/rav1e
cargo install cargo-c
if errorlevel 1 exit 1

:: Hmm, does conda-forge have cargo-c??
:: https://github.com/Homebrew/homebrew-core/blob/7d7fc5432ee7b16e7a7ce9f85951052f7ad55e96/Formula/rav1e.rb
cargo cinstall --library-type cdylib --release --prefix %LIBRARY_PREFIX%
if errorlevel 1 exit 1

:: rav1e includes a command line utility that cinstall will not install
cargo install --path . --root %LIBRARY_PREFIX%
if errorlevel 1 exit 1

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
if errorlevel 1 exit 1