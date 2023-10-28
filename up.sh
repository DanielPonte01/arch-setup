#!/bin/bash
# Author    : Erik Dubois
echo "Checking for newer files online first"
git pull
git add --all .
echo "####################################"
echo "Write your commit comment!"
echo "####################################"
read input
git commit -m "$input"
if grep -q main .git/config; then
	echo "Using main"
		git push -u origin main
fi

if grep -q master .git/config; then
	echo "Using master"
		git push -u origin master
fi

echo "################################################################"
echo "###################    Git Push Done      ######################"
echo "################################################################"

