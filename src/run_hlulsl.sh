#!/bin/sh

# HL!UL!SL run_hlulsl
# Copyright (C) 2013-2021 Ryan Finnie
# SPDX-License-Identifier: MPL-2.0

hldir="$(dirname "$(dirname "$(readlink "$0")")")"
MODNAME="hlulsl"

if [ -x "$hldir/hl.sh" ]; then
  exec "$hldir/hl.sh" -game ${MODNAME} "$@"
else
  echo "Cannot find hl.sh!"
  echo "Please use install.sh to install to the appropriate directory."
  exit 1
fi
