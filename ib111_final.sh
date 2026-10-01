#!/bin/bash

failed=0
pocet_skriptu=0
pocet_succ=0

if [[ $1 == "--sady" ]]; then
	sady=1
else
	sady=0
fi

echo "Spouštím test SANITY na přípravách ve složce $(pwd)"
echo "----------"
for FILE in *; do
	if [[ $sady -eq 0 && $(basename $FILE) == p* ]] || [[ $sady -eq 1 && $(basename $FILE) == [a-e]* ]]; then
		pocet_skriptu=$((pocet_skriptu + 1))
		echo "Spouštím $FILE"
		SECONDS=0
		if ! /home/modular/projects/archScripts/ib111_run.sh $FILE; then
			echo -e "\e[31mSANITY FAIL\e[0m"
			failed=1
		else
			echo -e "\e[92mSANITY SUCCESS\e[0m"
			pocet_succ=$((pocet_succ + 1))
		fi
		duration=$SECONDS
		echo "Skript trval přibližně $duration sekund."
		echo "----------"
	fi
done

if [[ $failed -eq 1 ]]; then
	echo -e "\e[31m$pocet_succ/$pocet_skriptu\e[0m"
	echo -e "\e[31mNěkteré přípravy selhaly.\e[0m"
else
	echo -e "\e[92m$pocet_succ/$pocet_skriptu\e[0m"
	echo -e "\e[92mVšechny přípravy uspěly.\e[0m"
fi
