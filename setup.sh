#!/bin/bash

PROJECT_FOLDER_PATH:= ${HOME}/projects
SCRIPT_GIT_REPO:= git@github.com:ModularEntree/archScripts.git
SCRIPT_FOLDER_NAME:= scripts

# TODO: Check if dependencies is installed
DEPEN = pacman -Q
if ! ($DEPEN | grep git > /dev/null && $DEPEN | grep openssh > /dev/null && $DEPEN | grep diffutils > /dev/null ); then
	echo "Dependencies are not installed (GIT | OPENSSH | DIFF)."; exit 1;
fi

# Checks, if ssh folder (and, I presume, sshkey) is set
if ! [ -d $HOME/.ssh ]; then
	echo "SSH key is not set, git clone will not work." ; exit 1;
fi

if ! [ -d $PROJECT_FOLDER_PATH ]; then
	echo "Creating projects folder..." ; mkdir $PROJECT_FOLDER_PATH;
fi

git clone $SCRIPT_GIT_REPO

REPO_FOLDER_NAME = `IFS=/; echo $SCRIPT_GIT_REPO | (while read GARBAGE NAME ;do echo ${NAME:0:-4}; done)`

mv $REPO_FOLDER_NAME $SCRIPT_FOLDER_NAME
ln -s $PROJECT_FOLDER_PATH/$SCRIPT_FOLDER_NAME $HOME/$SCRIPT_FOLDER_NAME

cat $PROJECT_FOLDER_PATH/SCRIPT_FOLDER_NAME/def_bashrc >> $HOME/.bashrc

