#!/bin/bash

REPOS_DIR="."

# change to the direcotry containing the repos
cd "$REPOS_DIR" || { echo "Directory $REPOS_DIR does not exist."; exit 1; }

# loop through each subdirectory
for dir in */; do
	# check if subdirectory exists and is a directory
	if [ -d "$dir" ]; then
		# change to the subdirectory
		cd "$dir" || continue

		# check if it is a git repository
		if [ -d ".git" ]; then
			echo "Pulling changes in $dir"
			git pull
		else
			echo "$dir is not a git repository."
		fi

		# change back to the parent directory
		cd ..
	fi
done
