#!/usr/bin/env bash
PROJECT_ROOT="$(pwd)"
rm -rf dist/linux
mkdir -p ./dist/linux
cd unzip/
make "linux"
cd $PROJECT_ROOT
flutter build linux --release
cp -r build/linux/x64/release/bundle/. $PROJECT_ROOT/dist/linux/.
cp -r ./unzip/build/linux/. $PROJECT_ROOT/dist/linux/lib/.
#generate tarball
tar -czvf mangakolekt.tar.gz ./dist/linux/
mv $PROJECT_ROOT/mangakolekt.tar.gz $PROJECT_ROOT/dist/linux