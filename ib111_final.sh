#!/bin/bash

failed=0

echo "Spouštím test SANITY na přípravách ve složce $(pwd)"
echo "----------"
for FILE in *; do
	if [[ $(basename $FILE) == p* ]]; then
		echo "Spouštím $FILE"
		SECONDS=0
		if ! /home/modular/projects/archScripts/ib111_run.sh $FILE; then
			echo -e "\e[31mSANITY FAIL\e[0m"
			failed=1
		else
			echo -e "\e[92mSANITY SUCCESS\e[0m"
		fi
		duration=$SECONDS
		echo "Skript trval přibližně $duration sekund."
		echo "----------"
	fi
done

if [[ $failed -eq 1 ]]; then
	echo -e "\e[31mNěkteré přípravy selhaly.\e[0m"
else
	echo -e "\e[92mVšechny přípravy uspěly.\e[0m"
fi
