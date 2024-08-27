HERE="$(dirname "$0")"

cd "$HERE/.."

has() {
    which "$1" >/dev/null
}

if [[ -n "$1" ]]; then
    mkdir -p bin
    if ! has curl; then
        echo "Need 'curl' to download pre-compiled binary for v${1} from web."
    fi

    curl -L "https://github.com/taikedz/os-release-q/releases/download/$1/os-release-$1" -o bin/os-release

elif has go && has make; then
    make

else
    echo "Cannot build locally. Specify a version like '0.0.2' ."
    exit 1
fi


if [[ "$UID" = 0 ]]; then
    TARGET=/usr/local/bin
else
    TARGET="$HOME/.local/bin"
    echo "Ensure '$TARGET' is in your '\$PATH'"
fi

if [[ ! -e "$TARGET" ]]; then
    mkdir -p "$TARGET"
fi

TARGET_BIN="$TARGET/os-release"
cp bin/os-release "$TARGET_BIN"
chmod 755 "$TARGET_BIN"

echo "Done."
