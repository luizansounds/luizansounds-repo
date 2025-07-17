#!/usr/bin/bash

repo_name='luizansounds-repo'
repo="${USER}@${ARKANE_REPO}${repo_name}/os/x86_64/"

if [[ $1 == 'add' ]]; then
	cd luizansounds-repo
	rm -rf pkgbuild
	rm -rf ./x86_64/$repo_name.db
    rm -rf ./x86_64/$repo_name.files
    cp ./*/*/*.pkg.tar.zst ./x86_64/
    cp ./*/*/*.pkg.tar.zst.sig ./x86_64/
	repo-add $repo_name.db.tar.zst ./*/*pkg.tar.zst
	rm -rf $repo_name.db
	rm -rf $repo_name.files
	mv ./$repo_name.db.tar.zst ./x86_64/$repo_name.db
	mv ./$repo_name.files.tar.zst ./x86_64/$repo_name.files
	git add .
	git commit -m "UPDATE REPOSITORY"
	git push
	
elif [[ $1 == 'build' ]]; then
    git clone https://github.com/luizansounds/luizansounds-repo.git
	cd luizansounds-repo
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
	rm -rf pkgbuild
    cp ./*/*/*.pkg.tar.zst ./x86_64/
    cp ./*/*/*.pkg.tar.zst.sig ./x86_64/
	repo-add $repo_name.db.tar.zst ./*/*pkg.tar.zst
	rm -rf $repo_name.dbexi
	rm -rf $repo_name.files
	mv ./$repo_name.db.tar.zst $repo_name.db
	mv ./$repo_name.files.tar.zst $repo_name.files
	git add .
	git commit -m "UPDATE REPOSITORY"
	git push

elif [[ $1 == 'clear' ]]; then

	rm ./*.old

elif [[ $1 == 'clear' ]]; then

    git clone https://github.com/luizansounds/luizansounds-repo.git

elif [[ $1 == 'push' ]]; then

	scp ./$repo_name.* $repo
	scp ./*/*.pkg.tar.zst $repo
	scp ./*/*.pkg.tar.zst.sig $repo

else
	printf "No valid parameter provided\n"
fi
