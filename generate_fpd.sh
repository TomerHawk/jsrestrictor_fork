#!/usr/bin/env bash

#  JavaScript Restrictor is a browser extension which increases level
#  of security, anonymity and privacy of the user while browsing the
#  internet.
#
#  Copyright (C) 2021  Marek Salon
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

# Use a temporary file for in-place editing
TMP_FILE=$(mktemp /tmp/fp_levels_tmp.XXXXXX)
trap 'rm -f "$TMP_FILE"' EXIT

sed '/.*\/\/DEF_FPD_FILES_S.*/,/.*\/\/DEF_FPD_FILES_E.*/{/.*\/\/DEF_FPD_FILES_S.*/!{/.*\/\/DEF_FPD_FILES_E.*/!d;}}' "$1/fp_levels.js" > "$TMP_FILE"
mv "$TMP_FILE" "$1/fp_levels.js"

CONFIG_FILES=$(find common/fp_config/* -maxdepth 0 -name "*.json")
ACC=$(printf "\"%s\"," $(basename -s .json $CONFIG_FILES))

if [ -n "$ACC" ]; then
  awk -v config_files="$ACC" '/.*\/\/DEF_FPD_FILES_S.*/{print; print "var fp_config_files = [" config_files "];"; next}1' "$1/fp_levels.js" > "$TMP_FILE"
  mv "$TMP_FILE" "$1/fp_levels.js"
fi
