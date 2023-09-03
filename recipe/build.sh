set -ex

cargo cinstall --library-type cdylib --release --prefix "${PREFIX}"

# rav1e includes a command line utility that cinstall will not install
cargo install --path . --root "${PREFIX}"

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
