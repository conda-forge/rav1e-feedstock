set -ex

# cargo-c is a rust build tool that generates shared library and pkgconfig
# it is installed into the build prefix
# https://github.com/xiph/rav1e
cargo install cargo-c

# Required for cross-compiling
export PKG_CONFIG_SYSROOT_DIR=$PREFIX
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

# Hmm, does conda-forge have cargo-c??
# https://github.com/Homebrew/homebrew-core/blob/7d7fc5432ee7b16e7a7ce9f85951052f7ad55e96/Formula/rav1e.rb
cargo cinstall --library-type cdylib --release --prefix "${PREFIX}"

# rav1e includes a command line utility that cinstall will not install
cargo install --path . --root "${PREFIX}"

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
