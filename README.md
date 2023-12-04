# Game On Flutter

This project is flutter application. 

## Getting Started
Clone git repository to your machine : https://github.com/encodedots/game-on-app.git

**Environment**
- Operating System : Ubuntu 22.04.1 LTS 64-bit
- Flutter : 3.7.12 stable version
- Dart : 2.19.6
- Java SDK : 11

**Supported Versions**
- Android : Android 9 and above.
- Compile Android SDK Version : android-33
- iOS : ios 11 and above.

## Project Structure
This application uses GetX architectural pattern. There is a controller file for each screen to 
separate business logic from UI file. 

The Dio plugin helps network calls in effective manner and no need to add manual logs as it also
provide request and response logs in console.

get_cli plugin generate boilerplate code for GetX architecture with routing and binding to prevent
extra time to manually create them.

**About GetX**
GetX is an extra-light and powerful solution for Flutter. It combines high-performance 
state management, intelligent dependency injection, and route management quickly and practically.

**Important Plugins**
- get
- firebase_core
- firebase_messaging
- get_cli
- connectivity_plus

See here [https://pub.dev/packages/get] for more details.

