#!/bin/bash

# usage:

# to create a debian package file that contains the application, run: 
#        ./create_debian_package_ubuntu_18_04.sh

# to create a debian source package file that can be uploaded to Launchpad run 
#        export gpgkey=YOUR_GPG_KEY 
#        ./create_debian_package_ubuntu_18_04.sh src


#set target
target=SOURCE_PACKAGE
if [ $# -eq 0 ]; then
    target=BINARY_PACKAGE
fi

#remove old build dir
rm -rf build-debian

#cp marley into build dir
mkdir build-debian
cp -r marley build-debian/

#set up debian build
cp build-debian/marley/debian/marley_*18.04.dsc build-debian/
cp build-debian/marley/debian/control\ ubuntu\ 18.04 build-debian/marley/debian/control 
rm -rf build-debian/marley/.git


#change into marley root
cd build-debian/marley

if [ $target == "BINARY_PACKAGE" ]; then
  #generate deb file (a.k.a application package)
  debuild -uc -us
  ls -lah ../*.deb
else
  #create Launchpad upload package (a.k.a source package), gpgkey must be set
  debuild -S -sa -k$gpgkey
  cd ..
  #send it!
  dput ppa:beauman/marley marley_*_source.changes
fi
