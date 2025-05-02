#!/bin/bash

#  ##########
# #          #
# #          #
#  ##########

# Help functions

function getCol () {
	if [[ ! -v 1 ]]; then
		echo "Chyba, nebyl dodán první argument"
		exit 1
	elif [[ ! -v 2 ]]; then
		echo "Chyba, nebyl dodán druhý argument"
		exit 1
	fi

	local colPart1=$1
	local colPart2=$2
	local colorPrefix='\033['
	local colorSufix='m'
	echo "${colorPrefix}${colPart1};${colPart2}${colorSufix}"
}

function echoCol () {
	if [[ ! -v  1 ]]; then
		echo "Chyba, nebyl dodán první argument (barva v escape formě)"
		exit 1
	elif [[ ! -v 2 ]]; then
		echo "Chyba, nebyl dodán druhý argument (zpráva)"
		exit 1
	fi

	local newColor=$1
	local message=$2
	local resetColor='\033[0m'
	echo -e "${newColor}${message}${resetColor}"
}

function getEmptyString () {
	local length=$1
	printf '%*s' "$length"
}

function fillStringWith () {
	local char=$1
	local length=$2
	local toReturn=""
	for i in $(seq 1 ${length});
	do
		toReturn="${toReturn}${char}"
	done
	echo "${toReturn}"
}

# MAIN

# Colors
greenCol=$(getCol 0 32)
redCol=$(getCol 0 31)
yellowCol=$(getCol 1 33)

# Battery constants
batteryCharging='Charging'

# Battery vars
batteryCapacity=$(cat /sys/class/power_supply/BAT0/capacity)
batteryStatus=$(cat /sys/class/power_supply/BAT0/status)

# Ascii art specifika
artFillShell='#'
artFillPower='X'
artFillEmptyPower='O'
artEmptySpace='5'
artBatShellWidth='3'
artBatOutShellHeight=$(( $artBatShellWidth * 2 ))
artBatProgressParts='7'
artBatProgressPartWidth=$(( $artBatShellWidth * 2 ))

echo -e "\n"

for i in $(seq 1 ${artBatShellWidth});
do
	artRow="$(getEmptyString $artEmptySpace)$(getEmptyString $artBatShellWidth)"
	for i in $(seq 1 ${artBatProgressParts});
	do
		artRow="${artRow}$(fillStringWith "${artFillShell}" ${artBatProgressPartWidth})"
	done
	echo -e "${artRow}"
done

for i in $(seq 1 ${artBatOutShellHeight});
do
	artRow="$(getEmptyString $artEmptySpace)"
	artRow="${artRow}$(fillStringWith "${artFillShell}" ${artBatShellWidth})"
	for i in $(seq 1 ${artBatProgressParts});
	do
		useCol=""
		fillStr=""
		batCap=$(( batteryCapacity/ $(( 100 / artBatProgressParts )) ))
		if [[ batCap -lt 1 ]];then
			useCol="${redCol}"
		elif [[ $batteryStatus == $batteryCharging ]];then
			useCol="${yellowCol}"
		else
			useCol="${greenCol}"
		fi
		if [[ batCap  -ge $(( i-1 )) ]];then
			fillStr="$(echoCol ${useCol} "${artFillPower}")"
		elif [[ batCap -lt 1 ]] && [[ i -eq 1 ]];then
			fillStr="$(echoCol ${useCol} "${artFillPower}")"
		else
			fillStr="${artFillEmptyPower}"
		fi
		artRow="${artRow}$(fillStringWith ${fillStr} ${artBatProgressPartWidth})"
	done
	artRow="${artRow}$(fillStringWith "${artFillShell}" ${artBatShellWidth})"
	echo -e "${artRow}"
done

for i in $(seq 1 ${artBatShellWidth});
do
	artRow="$(getEmptyString $artEmptySpace)$(getEmptyString $artBatShellWidth)"
	for i in $(seq 1 ${artBatProgressParts});
	do
		artRow="${artRow}$(fillStringWith "${artFillShell}" ${artBatProgressPartWidth})"
	done
	echo -e "${artRow}"
done

echo -e "\n"
