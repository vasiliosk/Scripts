#!/bin/sh
################################################################################
#
#	blueserial.sh
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
#	This script is used for automating bluetooth serial (SPP) connections and
#	output via the commandline. Specifically, using this instead of the blueman
#	package is more reliable for bluetooth development.
#
################################################################################

PROG_NAME="blueserial"
USR_NAME=$(echo $USER)
#USR_TMP_DIR="/home/"${USR_NAME}
USR_TMP_DIR="/tmp"
TMP_FILE=${USR_TMP_DIR}"/.blueserial.tmp"
TMP_MACS=${USR_TMP_DIR}"/.blueserial_MACS.tmp"
TMP_NAMES=${USR_TMP_DIR}"/.blueserial_NAMES.tmp"
TMP_CONN=${USR_TMP_DIR}"/.blueserial_CONN.tmp"
dev_mac=""

case ${USR_NAME} in
	root) echo ${USR_NAME}
		break ;;
	*)	echo ""
		echo  " ${USR_NAME}:  Please execute the script using 'sudo'" 
		echo ""
		echo " example: 'sudo '"
		exit 0	;;
	esac	#	end switch
	
#--- Menu ---------------------------------------------------------------------#
MENU_MESG="\n\n Here are some options:\n\t
(1) List Bluetooth adapter MAC address\n\t
(2) Scan for devices and list all that are visible\n\t
(3) Disconnect from device\n\t
(9)	Display active connections\n\t
(s) Start serial connection\n\t
(i) Info and Stats\n\t
(d) Disconnect from device\n\t
(0) exit\n\t"

#--- Greeting -----------------------------------------------------------------#
sudo sh -c "echo ' '"
printf "\n\n"
printf " ################################################################################\n\n"
printf " %s - Bluetooth Serial\n\n" ${PROG_NAME}
printf " This script is used for automating bluetooth serial (SPP) connections and\n"
printf " output via the commandline.\n"
printf "\n ################################################################################\n\n"

echo -n ${MENU_MESG}
printf "\n>> "


#--- Main Loop ----------------------------------------------------------------#
while read input ;do
	case $input in
		1) echo ""	#	List the adapter information
#			sh -c "sudo hcitool dev"
			hcitool dev
			;;
		2) echo ""	#	Scan for devices and list all that are visible
			echo -n "Scanning ... "
			#	Redirect the output of the scan, removing the 1st line using
			#	"sed '[n]d'", where n=1
			sh -c "sudo hcitool scan | sed '1d' > ${TMP_FILE}"
			#	Get the Number of devices, using "sed -n '[i]p'", where i is the
			#	desired line number to print to std out
			num_devices=$(sh -c "cat -n ${TMP_FILE} | tac | cut -c 6-8 | sed -n '1p'")
			printf "Number of Devices Available: %d\n" ${num_devices}

			$(cat ${TMP_FILE} | cut -c 2-18 > ${TMP_MACS})
			$(cat ${TMP_FILE} | cut -c 20-100 > ${TMP_NAMES})

			cat -n ${TMP_FILE}

#			echo "TMP_MACS:"
#			cat ${TMP_MACS}
#			echo "TMP_NAMES:"
#			cat ${TMP_NAMES}
#			VERSION=$(cat ${TMP_FILE} | sed '2q;d' | cut -c 10-13)
#			cat ${VERSION}
			;;
#			hcitool scan	;;
		\s) echo ""	#	Start serial connection
		 	echo " Select the specified MAC address, using channel n.\n To exit, enter '0'\n\t"
		 	printf "\n>> "
		 	
		 	while read selection ;do
		 		case ${selection} in
		 			[1-9]) echo ""
		 				dev_mac=$(sh -c "cat ${TMP_MACS} | sed -n '${selection}p'")
						printf "\nConnecting to device addr: %s\n" ${dev_mac}
						echo ${dev_mac} > ${TMP_CONN}
						cat ${TMP_CONN}
						ser_port="/dev/rfcomm0"
#		 				$(rfcomm connect ${ser_port} ${dev_mac} 8)
#		 				$(rfcomm connect /dev/rfcomm3 34:81:F4:27:D7:71 8)
						$(gnome-terminal -x rfcomm connect ${ser_port}  ${dev_mac} 8 &&
						sleep 2 && gnome-terminal -x cat ${ser_port}  )
						break
		 				;;
		 			0)
		 				echo ${MENU_MESG}
		 				break
		 				;;
		 			*) echo ""
		 				;;
		 		esac	#	end switch
				echo "Select the specified MAC address, using channel n\n\t"
			 	printf "\n>> "
				done </dev/tty	#	end while loop
			
			;;	#	end switch case 's'
		9) echo ""	#	Display active connections
			hcitool con
			;;
		i) echo ""	#	Info and Stats
			tmp_addr=$(cat ${TMP_CONN})
			printf "\n Info and settings\n =================\n"
			sh -c "hcitool info ${tmp_addr}"	#	Device info
			sh -c "hcitool lq ${tmp_addr}"		#	Link quality
			sh -c "hcitool rssi ${tmp_addr}"	#	Display connection RSSI
			sh -c "hcitool tpl ${tmp_addr}"	#	Display transmit power level
			printf " ================================================================================\n"
			;;
		d) echo ""	#	Disconnect
			tmp_addr=$(cat ${TMP_CONN})
			hcitool dc ${tmp_addr}
			;;
		0) echo ""	#	Exit
			printf "\n Thank you for using %s. Goodbye!\n\n" ${PROG_NAME}
			break	;;
		\h|\?*) echo ${MENU_MESG}	;;
		
		*) echo ""
			printf "\n\t>> Please enter a valid selction! <<\n"
			printf "\n\t>> Remember, you may enter 'h' or '?' to display options. <<"
			;;
	esac	#	end switch
	
	printf "\n>> "
done </dev/tty	#	end while loop



exit 0
################################################################################
