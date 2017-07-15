#!/bin/bash


sh -c "sudo apt-get remove binutils-arm-none-eabi gcc-arm-none-eabi"
sudo add-apt-repository ppa:terry.guo/gcc-arm-embedded
sudo apt-get update
sudo apt-get install gcc-arm-none-eabi

exit
