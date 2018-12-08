# mg_oauth2
![mg_oauth2|512x512](https://github.com/BroCode9/mg-oauth2/blob/develop/logo.png)

Ever been driven off by lack of documentation and amount of code you need to write just to start using Microsoft Graph API?
Lack of documentation isn't helping either.

## Table of Contents

- [Our Goal](#our-goal)
- [Getting Started](#getting-started)
  - [Installing Flutter SDK](#installing-flutter-sdk)
  - [Set your path](#set-your-path)

## Our Goal

MG-Oauth2 is intended to ease using Graph API and make you focus on your own work. What's even better we mapped most of important objects so you can start retrieving users, their emails and calendar data. 

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).

### Installing Flutter SDK

1. [Download the Flutter SDK](https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_v1.0.0-stable.zip)
2. Create a directory and unzip the SDK.
3. Extract the SDK on desired location for example:<br/>
`cd ~/development`<br/>
`unzip ~/Downloads/flutter_macos_v1.0.0-stable.zip`<br/>
4. Add the flutter tool to your path:<br/>
`export PATH=$PATH:``pwd``/flutter/bin`<br/>
*Note:* The above command sets your PATH temporarily, for the current terminal session. To permanently add Flutter to your path, see [Set your path](#set-your-path)

### Set your path
If you want to run Flutter in any terminal session, you need to update PATH variable permanently. The steps for modifying this variable permanently for all terminal sessions are machine-specific. Typically you add a line to a file that is executed whenever you open a new window. For example:<br/>
1. Determine the directory where you placed the Flutter SDK. You will need this in Step 3.
2. Open (or create) `$HOME/.bash_profile`. The file path and filename might be different on your machine.
3. Add the following line and change `[PATH_TO_FLUTTER_GIT_DIRECTORY]` to be the path where you cloned Flutter’s git repo:<br/>
`export PATH=$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin`
4. Run `source $HOME/.bash_profile` to refresh the current window.
5. Verify that the flutter/bin directory is now in your PATH by running:
`echo $PATH`
