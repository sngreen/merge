#!/bin/bash

function start_empty {
	rm -rf .git
	echo > test.file.txt
}

function init_repository {
	git init
	git add --all
	git commit -m "initial commit to master"
}

function create_branches {
	cat branches.txt | while read branch
	do
		git checkout -b $branch
		sleep 1
		git checkout master
	done
}

function update_branch {
	branch=$1
	git checkout $branch

	echo $branch >> test.file.txt
	
	git commit -am "branch: $branch"
	
	echo "updated      => $branch"
	      
	sleep 2
	git checkout master
}

start_empty
init_repository
create_branches 

# update the lowest in the list branch
update_branch $(head -n 1 branches.txt)

# merge the change up
printf '=%.0s' {1..35}; echo 
python merge.py 
sleep 3

# update branch from the middle of the stack
update_branch $(head -n 5 branches.txt | tail -n 1)

# merge the change up
printf '=%.0s' {1..35}; echo 
python merge.py 
sleep 3

# so far so good!
# now let's update and merge the branch from the bottom of the stack again

# update the lowest branch
update_branch $(head -n 1 branches.txt)

# merge the change up
printf '=%.0s' {1..35}; echo 
python merge.py 
sleep 3
