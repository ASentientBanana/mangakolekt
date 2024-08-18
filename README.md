# Mangkolekt

A lightweight manga reader made with flutter and go.
Currently, Windows, Linux and android are supported.

## Building
### Building for Linux/Android 
Building for linux along with building the dynamic libraries can be done using the command: 
\
\
`make build-linux`

This method requires you to pull the submodule unzip (name will probably change)\
\
You can find the repo [here](https://github.com/ASentientBanana/mangakolekt_unzip_module).
\
It's recommended if to clone the main repo using the command:
\
\
`git clone --recurse-submodules -j8 git@github.com:ASentientBanana/mangakolekt.git`
\
\
Running the make file calls the script `linux.sh` script located at the root of the project in the build_scripts dir.

This builds the dynamic libraries from the submodule go code, copies the output to the correct locations and runs the flutter build.
If you don't want to build the dynamic libraries just use the flutter build system.
#### Linux
`flutter build linux --release`
#### Windows
```
# Using make
make windows-zip

# Manual
# Run the script located in the project root in the build_scripts directory

.\build_scripts/windows.ps1
```
#### Android
`flutter build apk `  
\
This command results in three APK files:
   * [project]/build/app/outputs/apk/release/app-armeabi-v7a-release.apk
   * [project]/build/app/outputs/apk/release/app-arm64-v8a-release.apk
   * [project]/build/app/outputs/apk/release/app-x86_64-release.apk

\
Additional information for building an android version can be found [here](https://docs.flutter.dev/deployment/android).

Generating the ffi bindings is done by running:
`dart run ffigen`