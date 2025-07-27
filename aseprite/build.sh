#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(realpath "$(dirname "$0")")"

if [ ! -d ~/dev/aseprite ]; then
    mkdir -p ~/dev/aseprite
    git clone --recursive https://github.com/aseprite/aseprite.git ~/dev/aseprite
fi

cd ~/dev/aseprite

git reset --hard HEAD
git clean -fdx
git checkout main
git pull
git submodule update --init --recursive

docker compose -f "$SCRIPT_DIR/docker-compose.yaml" up --build aseprite

rm -rf ~/.aseprite
mkdir -p ~/.aseprite
cp -r ./build/bin/* ~/.aseprite/

cat <<'EOF' > ~/.local/bin/aseprite
#!/usr/bin/env bash

exec "$HOME/.aseprite/aseprite" "$@" &
EOF

chmod +x ~/.local/bin/aseprite

echo "✅ Build successful."
