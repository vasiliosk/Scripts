#!/bin/sh
################################################################################
#
#	make_script_executable.sh
#	
#	Copyright (C) 2017 Vasilios K. Kapogianis
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
#	This script is used for copying a script file to a directory that allows
#	most users to execute from.
#
################################################################################

#	Destination directory, where most users will be able to execute from (as long
#	as it's in their $PATH)
USR_EXEC_DIR="/usr/local/sbin/"
#	Script privileges
SCRIPT_PRIV="+x"
USR_NAME=$(echo $USER)
SRIPT_LOC=$(pwd)

#	verify the user entered the correct number of paramaters
if [ -n "$1" ]              # Tested variable is quoted.
then
#	Check to see whether the script is being run by a user with elevated privileges
#	if not, kindly remind them and exit.
case ${USR_NAME} in
	root) break ;;
	*)	echo ""
		echo  " ${USR_NAME}:  Please execute the script using 'sudo'" 
		echo ""
		echo " example: 'sudo '"
		exit 0	;;
	esac	#	end switch

MINPARAMS=1
SRIPT_NAME=$1

extension="${SRIPT_NAME##*.}"
echo ${extension}
filename="${SRIPT_NAME%.*}"
echo ${filename}
echo ${SRIPT_NAME}

#	Copy the file and make it executable
cp ${SRIPT_LOC}/${SRIPT_NAME} ${USR_EXEC_DIR}/${filename}
chmod ${SCRIPT_PRIV} ${USR_EXEC_DIR}/${filename}

fi
#	remind the user of the minimum number of paramaters
if [ $# -lt "$MINPARAMS" ]
then
  echo
  echo "This script needs at least $MINPARAMS command-line arguments!"
fi


exit 0
################################################################################
