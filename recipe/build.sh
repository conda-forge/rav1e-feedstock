set -ex

if [[ "${HOST}" != "ppc64le*" ]]; then
    CARGO_TARGET="${HOST}"
    CARGO_TARGET="$(echo -n ${CARGO_TARGET} | sed "s/conda/unknown/")"
    CARGO_TARGET="$(echo -n ${CARGO_TARGET} | sed "s/darwin.*/darwin/")"
    CARGO_TARGET="$(echo -n ${CARGO_TARGET} | sed "s/arm64/aarch64/")"
    CARGO_EXTRA_ARGS="--target ${CARGO_TARGET}"
fi

cargo cinstall \
    --library-type cdylib \
    --release \
    --prefix "${PREFIX}" \
    ${CARGO_EXTRA_ARGS}

# rav1e includes a command line utility that cinstall will not install
cargo install \
    --path . \
    --root "${PREFIX}" \
    ${CARGO_EXTRA_ARGS}

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
