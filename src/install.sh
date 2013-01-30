#!/bin/sh

set -e

S="$(dirname "$0")"

if [ -e "$HOME/.local/share/Steam/SteamApps/common/Half-Life/hl.sh" ]; then
  B="$HOME/.local/share/Steam/SteamApps/common/Half-Life"
elif [ -e "$HOME/Library/Application\ Support/Steam/SteamApps/common/Half-Life/hl.sh" ]; then
  B="$HOME/Library/Application\ Support/Steam/SteamApps/common/Half-Life"
elif [ "$1" -a -e "$1/hl.sh" ]; then
  B="$1"
else
  echo "Cannot find Steam Half-Life installation directory!" >&2
  exit 1
fi

mkdir -p "$B/steamlink"
cat >"$S/run_steamlink.sh" <<EOM
#!/bin/sh

$B/hl.sh -game steamlink
EOM
chmod 0755 "$S/run_steamlink.sh"
cp -a "$S"/* "$B/steamlink/"
echo "Done!" >&2
