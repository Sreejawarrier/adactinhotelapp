# adactin_hotel_app

Flutter application for adactin hotel app.

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Process for running the project on an IDE

For running flutter code we either use Android Studio or Visual Studio Code either
is ok to use. We should be able to run code on iOS Simulator or Android Emulator,
if the system is Mac. For windows or other system only Android Emulator is possible
to run the project.

1. Download the Android Studio or Visual Studio Code from

- [Android Studio: Android Studio App](https://developer.android.com/studio)
- [VSCode: Visual Studio Code App](https://code.visualstudio.com)

Xcode for mac via appstore if using mac and trying to test on iOS Simulator.

2. Get the flutter stable branch SDK via

- [Flutter SDK: Stable SDK branch of flutter](git clone https://github.com/flutter/flutter.git)

3. If using Android studio -> Goto preferences and go to plugins and install Dart and Flutter.

4. If using Visual Studio Code -> Goto preferences -> extensions and install Android iOS Emulator, Dart and Flutter.

5. Now get the project of adactin hotel app from git and keep it in a folder of your choice. For opening project
   a. Via Android Studio -> Open Android studio -> File -> Open -> navigate to the folder of the project in that folder
   you should be seeing folder android, gen, ios, lib etc so open that folder.
   b. Via VSCode -> Open VSCode -> File -> open and similar to above steps.

6.Once after opening the project,
a. In Android Studio, you should be able to see the devices currently selected, main.dart in the top center of the screen. In the devices place
you should be seeing either latest device like iPhone X or iOS Simulator or Android Emulator for running the project.
b. In VSCode, you should be able to see the menu option Debug and in it start Debugging or Run without Debugging.

Imp Note: The path of the flutter should be set properly so that flutter commands can run.
If macOS is less than Catalina then
export PATH="$PATH:~/<path to your flutter sdk>/flutter/bin"
If macOS is Catalina then if the bash_profile has the path set into it
source ~/.bash_profile 
Like in your bash_profile you should have
export PATH="$PATH:/Users/<path to your flutter sdk>/flutter/bin":
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
