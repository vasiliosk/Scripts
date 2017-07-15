#!/bin/bash
################################################################################
#
#	createArch.sh
#	
#	This program is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#	
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#	
#	You should have received a copy of the GNU General Public License
#	along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#	
#	Copyright (C) 2016,2017 Vasilios K. Kapogianis
#	
#
#	Call this script with 1 paramater, for example
#	./createArch.sh v1_00
#
################################################################################

MINPARAMS=1

#	Days of backups to keep.
n=5

#	verify the user entered the correct number of paramaters
if [ -n "$1" ]              # Tested variable is quoted.
then

VERSION=$1
#	Change this path, so that it matches your own archive directory
BACKUP_DIR=~/Project_Archive
#	Change this path, so that it matches your own archive name scheme
FNAME="ARCH__Project-$VERSION"
MYDATE=$(date +"%m-%d-%Y")
NAME=${BACKUP_DIR}/${FNAME}__${MYDATE}.zip
cd ..
echo
local_tmp=$(pwd)
#	Delete files older than n days
$(find ${local_tmp} -name 'ARCH__*' -mtime +${n} -type f -delete)
echo "Creating archive for project version:  $VERSION "
echo $NAME
zip -qr $NAME src/
echo
echo "Done."
echo
fi

#	remind the user of the minimum number of paramaters
if [ $# -lt "$MINPARAMS" ]
then
  echo
  echo "This script needs at least $MINPARAMS command-line arguments!"
fi


exit 0
################################################################################
