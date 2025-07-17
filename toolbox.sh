#!/usr/bin/bash

repo_name='luizansounds-repo'
repo="${USER}@${ARKANE_REPO}${repo_name}/os/x86_64/"

if [[ $1 == 'add' ]]; then
    cp ./*/*/*.pkg.tar.zst ./x86_64/
    cp ./*/*/*.pkg.tar.zst.sig ./x86_64/
	repo-add $repo_name.db.tar.zst ./*/*pkg.tar.zst
	rm -rf $repo_name.dbexi
	rm -rf $repo_name.files
	mv ./$repo_name.db.tar.zst $repo_name.db
	mv ./$repo_name.files.tar.zst $repo_name.files	
elif [[ $1 == 'build' ]]; then
	rm -rf ./86_64/*
	git clone https://github.com/luizansounds/pkgbuild.git
	cd ./pkgbuild
	BASE_DIR=$(pwd)
	
	for dir in *;
	do
		if [ -d "$dir" ];
		then
			cd $dir
			makepkg -fcd --sign --key $(git config user.email)
			cd $BASE_DIR
		fi
	done
	
	cd ..
    cp ./*/*/*.pkg.tar.zst ./x86_64/
    cp ./*/*/*.pkg.tar.zst.sig ./x86_64/
	repo-add $repo_name.db.tar.zst ./*/*pkg.tar.zst
	rm -rf $repo_name.dbexi
	rm -rf $repo_name.files
	mv ./$repo_name.db.tar.zst $repo_name.db
	mv ./$repo_name.files.tar.zst $repo_name.files
	git push

elif [[ $1 == 'clear' ]]; then
	rm ./*.old
elif [[ $1 == 'push' ]]; then

	scp ./$repo_name.* $repo
	scp ./*/*.pkg.tar.zst $repo
	scp ./*/*.pkg.tar.zst.sig $repo
else
	printf "No valid parameter provided\n"
fi
