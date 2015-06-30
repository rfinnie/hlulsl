#!/bin/sh

set -e

S="$(dirname "$0")"

if [ -n "$1" ]; then
  if [ -e "$1/hl.sh" ]; then
    B="$1"
  else
    echo "$1 does not appear to be a valid Half-Life installation."
    exit 1
  fi
elif [ -e "$HOME/.steam/steam/steamapps/common/Half-Life/hl.sh" ]; then
  B="$HOME/.steam/steam/steamapps/common/Half-Life"
elif [ -e "$HOME/.steam/root/SteamApps/common/Half-Life/hl.sh" ]; then
  B="$HOME/.steam/root/SteamApps/common/Half-Life"
elif [ -e "$HOME/.local/share/Steam/SteamApps/common/Half-Life/hl.sh" ]; then
  B="$HOME/.local/share/Steam/SteamApps/common/Half-Life"
elif [ -e "$HOME/Library/Application\ Support/Steam/SteamApps/common/Half-Life/hl.sh" ]; then
  B="$HOME/Library/Application\ Support/Steam/SteamApps/common/Half-Life"
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
cp -a "$S"/src/* "$B/steamlink/"

# Hack to make the Half-Life: Uplink menu item in Steam work
if [ -e "$B/hl.exe" ]; then
  if [ ! -h "$B/hl.exe" ]; then
    echo "WARNING: hl.exe exists, but is not a symlink."
    echo "Did Steam install the base Windows version of Half-Life?"
    echo "Launching Half-Life: Uplink from the Steam menu will not likely work."
    echo
  fi
else
  ln -s hl.sh "$B/hl.exe"
fi

# Install symlink
[ -d "$HOME/bin" ] || mkdir -p "$HOME/bin"
ln -sf "$B/steamlink/run_steamlink.sh" "$HOME/bin/steamlink"

echo "Done!  You may launch SteamLink by running:"
echo "  $HOME/bin/steamlink"
