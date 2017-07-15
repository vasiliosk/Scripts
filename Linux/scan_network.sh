#!/bin/bash


echo
sudo sh -c "`echo`"

#IPs=$(sudo arp-scan --localnet --numeric --quiet --ignoredups | grep -E '([a-f0-9]{2}:){5}[a-f0-9]{2}' | awk '{print $1}')
#IPs=$(sudo sh -c "arp-scan --localnet --numeric --quiet --ignoredups | grep -E '([a-f0-9]{2}:){5}[a-f0-9]{2}' | awk '{print $1}'")
sudo sh -c "arp-scan --localnet --numeric --quiet --ignoredups | grep -E '([a-f0-9]{2}:){5}[a-f0-9]{2}' | awk '{print $1}' > __network_scan_results.txt"

echo
cat -n __network_scan_results.txt
echo


N=17; grep -o ".\{$N\}$" < __network_scan_results.txt > __network_scan_results-mac_addr.txt

#sudo sh -c "nmap "
exit
