#!/bin/sh
################################################################################
#
#	update_build_dir.sh
#	
#	Copyright (C) 2016,2017 Vasilios K. Kapogianis
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
#	This script is used for simplifying build directory updates. I found this to
#	be a useful tool when creating a new directory in my_project/src and eliminating the
#	"Oops!!! I forgot to create that directory in my_project/Release (or Debug)"
#
#	Just make sure to change your file extension type "F_EXT" below and create a
#	.phony in your makefile. This script assumes directory structure like this:
#
#		my_project/
#		├── src/
#		|	├── config/
#		|	├── resource/
#		|	└── modules/
#		|		└── New_Module/
#		|		|	├── new_foo.h
#		|		|	├── new_foo.c
#		|		└── This_Module/
#		|		|	├── this.h
#		|		|	├── this.c
#		|		└── That_Module/
#		|			├── that.h
#		|			├── that.c
#		└── Release/
#			├── config/
#			├── resource/
#			└── modules/
#				└── This_Module/
#				└── That_Module/
#			    └── New_Module/		<----- Creates this!
#
################################################################################

#	Todays date.
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
TODAY=$MONTH"-"$DAY"-"$YEAR
#	Current time.
TIME=$(date +"%H:%M:%S")
#	File extension type
F_EXT="'*.c'"
#	Current server's hostname.
this_SRV=${HOSTNAME}
this_SRV=$(hostname)
#	Build location.
build_dir=$(pwd)
dir_list=${build_dir}/directory_struct.txt
echo ${build_dir}

cd ..

#	Project location.
project_dir=$(pwd)
src_list=${project_dir}/"Src_File_List.txt"

echo ${project_dir}


cd ./src

#	Source location.
src_dir=$(pwd)

echo ${src_dir}

echo 

$(find ${src_dir} -type d > ${dir_list})
$(find ${src_dir} -name ${F_EXT} > ${src_list})

tmp="${project_dir}/"
echo ${tmp}
cut_len=${#tmp}

echo ${cut_len}

m=$(wc -l ${dir_list} | cut -c 1-3)

#	Loop and ensure that all the same directories appear in the build directory
for i in $(seq 1 ${m})
do
	tmpDir=$(sed "${i}q;d" ${dir_list} | cut -c ${cut_len}-500)
	new_dir=${build_dir}${tmpDir}
	$(mkdir -p ${new_dir})
done


#------------------------------------------------------------------------------#

cd ${build_dir}


exit 0
################################################################################
