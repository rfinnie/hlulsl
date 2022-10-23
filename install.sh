#!/bin/sh

# HL!UL!SL install
# Copyright (C) 2013-2021 Ryan Finnie
# SPDX-License-Identifier: MPL-2.0

set -e

S="$(dirname "$0")"
PRODUCT_NAME="HL!UL!SL - Half-Life: Uplink for Steam"
MODNAME="hlulsl"

if [ -n "$1" ]; then
  if [ -e "$1/hl.sh" ]; then
    INSTDIR="$1"
  else
    echo "$1 does not appear to be a valid Half-Life installation."
    exit 1
  fi
else
  for dir in \
    "$HOME/.steam/steam/steamapps/common/Half-Life" \
    "$HOME/.steam/root/SteamApps/common/Half-Life" \
    "$HOME/.local/share/Steam/SteamApps/common/Half-Life" \
    "$HOME/Library/Application\ Support/Steam/SteamApps/common/Half-Life" \
    "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Half-Life" \
  ; do
    if [ -e "${dir}/hl.sh" ]; then
      INSTDIR="${dir}"
      break
    fi
  done
fi
if [ -z "${INSTDIR}" ]; then
  echo "Cannot find Steam Half-Life installation directory!"
  echo "Please provide it by running:"
  echo "  $0 /path/to/Steam/SteamApps/common/Half-Life"
  exit 1
fi

echo "Ready to install ${PRODUCT_NAME} to: $INSTDIR/${MODNAME}"
echo "Proceed? [y/N]"; read CONFIRM
if [ ! "$CONFIRM" = "y" ] && [ ! "$CONFIRM" = "Y" ]; then
  echo "Exiting."
  exit 1
fi

echo

# Copy files
mkdir -p "$INSTDIR/${MODNAME}"
cp -a "$S"/src/* "$INSTDIR/${MODNAME}/"

# Hack to make the menu item in Steam work
if [ -e "$INSTDIR/hl.exe" ]; then
  if [ ! -h "$INSTDIR/hl.exe" ]; then
    echo "WARNING: hl.exe exists, but is not a symlink."
    echo "Did Steam install the base Windows version of Half-Life?"
    echo "Launching Half-Life: Uplink from the Steam menu will not likely work."
    echo
  fi
else
  ln -s hl.sh "$INSTDIR/hl.exe"
fi

# Install symlink
[ -d "$HOME/bin" ] || mkdir -p "$HOME/bin"
ln -sf "$INSTDIR/${MODNAME}/run_${MODNAME}.sh" "$HOME/bin/${MODNAME}"

echo "Done!  You may launch ${PRODUCT_NAME} by running:"
echo "  $HOME/bin/${MODNAME}"
