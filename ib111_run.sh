#/bin/bash

if ! [[ $# -eq 1 ]]; then
	echo "Nebyl zadán soubor ke kontrole" >> /dev/stderr;
	exit 1
fi

if ! [[ -f ./ib111.toml ]]; then
	echo "Chybí konf. soubor ib111.toml" >> /dev/stderr;
	exit 1
fi

echo "Spouštím edulint" && \
edulint check --option "config-file=./ib111.toml" $1 >> /dev/stderr && \
# echo "Spouštím mypy" && \
#mypy --strict $1 && \
echo "Spouštím skript" && \
python3 $1
