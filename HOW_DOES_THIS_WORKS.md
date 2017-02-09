# Android Tamer build process

## Pre-Setup

1. Create a source folder in base
2. create s3cfg file in base directory
3. create a signing folder and put your PGP key inside it.
4. modify like 76 in Vagrantfile to point it to your PGP ID.
5. modify line 9 on bin/build_package 
6. modify line 2 and 3 to point to your email id and full name
7. ensure https://github.com/anantshri/script-collection/blob/master/gitrebase is in your base machine's path as we will be using it to rebase.

Note: this is on base machine as we need to use ssh keys / password for github access and that is better controlled outside VM and via base machines as we keep using github on base anyways


## Setup

1. Launch Packaging_tools VM
2. open 4 terminals
    3. vagrant ssh -> /vagrant/Build/
    4. vagrant ssh -> /vagrant/Tamer/Repository
    5. shell on Build/
    6. shell on source/ 
7. also open sublime on Build
7. Build shell will be used to execute build scripts which are sh build.sh in most cases.
8. Repository ssh will be used to pull files in repository or push files to aws
9. sublime on Build will be used to modify build scripts as and when needed
9. shell on Build will be used to commit to git repository the updated.
10. shell on source will be used to rebase the repositories.



## General upgrade process

1. go to source 
2. git rebase to latest version or commit point.
    3. gitrebase <remote repo url>
4. Go to Sublime: Open build script, modify version number as per the need.
5. Go to build shell: run sh build.sh <- this will generate the deb along with the key signing.
6. Go to Repository shell : pullme <deb_file_path> to pull the deb in repository (old_deb will be deleted)
7. Same shell pushme to push the repository to aws server.
8. once build is done also push Build script update to git repo. 
9. git add Build/<package>/build.sh Build/<package>/changelog Build/<package>/control
10. git commit -S -m "Commit note"
11. git push


Note: Some packages might not require rebase and are directly made available via original repositories
