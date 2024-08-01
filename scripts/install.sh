HERE="$(dirname "$0")"

cd "$HERE/.."

make

if [[ "$UID" = 0 ]]; then
    TARGET=/usr/local/bin
else
    TARGET="$HOME/.local/bin"
    echo "Ensure '$TARGET' is in your '\$PATH'"
fi

if [[ ! -e "$TARGET" ]]; then
    mkdir -p "$TARGET"
fi

cp bin/os-release "$TARGET/"

echo "Done."
