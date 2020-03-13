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

## Notes

1. Download the Android Studio or Visual Studio Code from
Android Studio: Android Studio App
VSCode: Visual Studio Code App
Xcode for mac via appstore if using mac and trying to test on iOS Simulator.

Steps to install Xcode in mac:

Install the latest stable version of Xcode (using web download or Mac App store)
Configure Xcode command line tools to use the newly installed version of Xcode by running the command line

$ sudo Xcode-select --switch /Applicatins/Xcode.app/Contents/Developer
$sudo xcode build -runFirstLaunch

NOTE: Make sure Xcode license agreement is signed by opening Xcode

2. Get the flutter stable branch SDK via
[Flutter SDK: Stable SDK branch of flutter](git clone https://github.com/flutter/flutter.git)
3. If using Android studio -> Goto preferences and go to plugins and install Dart and Flutter.

Set path of Android SDK in Android Studio

4. If using Visual Studio Code -> Goto preferences -> extensions and install Android iOS Emulator, Dart and Flutter.

5. Now get the project of adactin hotel app from git and keep it in a folder of your choice. For opening project a. Via Android Studio -> Open Android studio -> File -> Open -> navigate to the folder of the project in that folder you should be seeing folder android, gen, ios, lib etc so open that folder. b. Via VSCode -> Open VSCode -> File -> open and similar to above steps.
via Xcode-> Open project in Android Studio>Right Click on the ios module within the project>Click on Flutter>Click on Open iOS module in Xcode

6.Once after opening the project, a. In Android Studio, you should be able to see the devices currently selected, main.dart in the top center of the screen. In the devices place you should be seeing either latest device like iPhone X or iOS Simulator or Android Emulator for running the project. b. In VSCode, you should be able to see the menu option Debug and in it start Debugging or Run without Debugging.

7. For running the project through Appium, set android_home in bash_profile, install pre-requisites for Appium: (Homebrew, node.js, carthage through terminal) and install appium on terminal

Imp Note: The path of the flutter should be set properly so that flutter commands can run. If macOS is less than Catalina then export PATH="$PATH:~//flutter/bin" If macOS is Catalina then if the bash_profile has the path set into it source ~/.bash_profile Like in your bash_profile you should have export PATH="$PATH:/Users//flutter/bin": export LC_ALL="en_US.UTF-8" export LANG="en_US.UTF-8"

## Steps for reducing response timeout are
1. Once you open the project via Android Studio Or VSCode,
2. Goto file under lib/global/global_constants.dart
3. In that you can a variable called `sessionTimeout` currently set at 60, this can be reduced to required number of seconds and run the project.
4. `spinnerTimeout` is for handling the spinner timeout which will be equal to sessionTimeout.
5. If you want to reduce the user app session timeout field is `userSessionTimerMaxInSeconds` which is currently set at 1800 seconds.