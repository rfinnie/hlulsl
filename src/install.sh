#!/bin/sh

set -e

S="$(dirname "$0")"

if [ -e "$HOME/.steam/root/SteamApps/common/Half-Life/hl.sh" ]; then
  B="$HOME/.steam/root/SteamApps/common/Half-Life"
elif [ -e "$HOME/.local/share/Steam/SteamApps/common/Half-Life/hl.sh" ]; then
  B="$HOME/.local/share/Steam/SteamApps/common/Half-Life"
elif [ -e "$HOME/Library/Application\ Support/Steam/SteamApps/common/Half-Life/hl.sh" ]; then
  B="$HOME/Library/Application\ Support/Steam/SteamApps/common/Half-Life"
elif [ "$1" -a -e "$1/hl.sh" ]; then
  B="$1"
else
  echo "Cannot find Steam Half-Life installation directory!"
  echo "Please provide it by running:"
  echo "  $0 /path/to/Steam/SteamApps/common/Half-Life"
  exit 1
fi

echo "Ready to install SteamLink to: $B/steamlink"
echo "Proceed? [y/N]"; read CONFIRM
if [ ! "$CONFIRM" = "y" ] && [ ! "$CONFIRM" = "Y" ]; then
  echo "Exiting."
  exit 1
fi

echo

# Copy files
mkdir -p "$B/steamlink"
cp -a "$S"/* "$B/steamlink/"

# Create run script
cat >"$B/steamlink/run_steamlink.sh" <<EOM
#!/bin/sh

$B/hl.sh -game steamlink "$@"
EOM
chmod 0755 "$B/steamlink/run_steamlink.sh"

# Install symlink
[ -d "$HOME/bin" ] || mkdir -p "$HOME/bin"
ln -sf "$B/steamlink/run_steamlink.sh" "$HOME/bin/steamlink"

echo "Done!  You may launch SteamLink by running:"
echo "  $HOME/bin/steamlink"
