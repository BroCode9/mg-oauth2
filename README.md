# mg_oauth2
![mg_oauth2|512x512](https://github.com/BroCode9/mg-oauth2/blob/develop/logo.png)

Ever been driven off by lack of documentation and amount of code you need to write just to start using Microsoft Graph API?
Lack of documentation isn't helping either.

## Table of Contents

- [Our Goal](#our-goal)
- [System requirements](#system-requirements)
  - [Windows](#windows)
  - [macOS](#macos)
  - [Linux](#linux)
- [Getting Started](#getting-started)
  - [Installing Flutter SDK](#installing-flutter-sdk)
    - [Windows](#windows)
    - [macOS](#macos)
    - [Linux](#linux)
  - [Set your path](#set-your-path)

## Our Goal

MG-Oauth2 is intended to ease using Graph API and make you focus on your own work. What's even better we mapped most of important objects so you can start retrieving users, their emails and calendar data. 

## System requirements

### Windows

* **Operating Systems:** Windows 7 SP1 or later (64-bit)
* **Disk Space:** 400 MB (Without IDE/tools)
* **Tools:** Flutter depends on these tools:
  - [Windows PowerShell 5.0](https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell?view=powershell-6) or newer (this is pre-installed with Windows 10)
  - [Git for Windows](https://git-scm.com/download/win), with the Use Git from the Windows Command Prompt option.

### MacOS

* **Operating Systems:** macOS (64-bit)
* **Disk Space:** 700 MB (Without IDE/tools)
* **Tools:** Flutter depends on these tools:
  - ```bash, mkdir, rm, git, curl, unzip, which```
  
### Linux

* **Operating Systems:** Linux (64-bit)
* **Disk Space:** 600 MB (Without IDE/tools)
* **Tools:** Flutter depends on these tools:
  - ```bash, mkdir, rm, git, curl, unzip, which```
* **Shared libraries:** Flutter `test` command depends on this library being available in your environment.
  - ```libGLU.so.1``` - provided by mesa packages e.g. ```libglu1-mesa``` on Ubuntu/Debian
  
## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).

### Installing Flutter SDK

#### Windows
1. [Download the Flutter SDK](https://storage.googleapis.com/flutter_infra/releases/stable/windows/flutter_windows_v1.0.0-stable.zip)
2. Extract the zip file and place the contained `flutter` in the desired installation location for the Flutter SDK (eg. `C:\src\flutter`; do not install Flutter in a directory like `C:\Program Files\` that requires elevated privileges)<br/>
3. Locate the file `flutter_console.bat` inside the `flutter` directory. Start it by double-clicking.<br/>
*Note:* The above command sets your PATH temporarily, for the current terminal session. To permanently add Flutter to your path, see [Set your path](#set-your-path)
5. Run flutter doctor:<br/>
`flutter doctor [-v]`<br/>
This command checks your environment and displays a report to the terminal window. The Dart SDK is bundled with Flutter; it is not necessary to install Dart separately. Check the output carefully for other software you may need to install or further tasks to perform.<br/><br/>

#### macOS
1. [Download the Flutter SDK](https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_v1.0.0-stable.zip)
2. Create a directory and unzip the SDK.
3. Extract the SDK on desired location for example:<br/>
`cd ~/development`<br/>
`unzip ~/Downloads/flutter_macos_v1.0.0-stable.zip`<br/>
4. Add the flutter tool to your path:<br/>
```export PATH=$PATH:`pwd`/flutter/bin```<br/>
*Note:* The above command sets your PATH temporarily, for the current terminal session. To permanently add Flutter to your path, see [Set your path](#set-your-path)
5. Run flutter doctor:<br/>
`flutter doctor [-v]`<br/>
This command checks your environment and displays a report to the terminal window. The Dart SDK is bundled with Flutter; it is not necessary to install Dart separately. Check the output carefully for other software you may need to install or further tasks to perform.<br/><br/>

#### Linux
1. [Download the Flutter SDK](https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.0.0-stable.tar.xz)
2. Create a directory and unzip the SDK.
3. Extract the SDK on desired location for example:<br/>
`cd ~/development`<br/>
`tar xf ~/Downloads/flutter_linux_v1.0.0-stable.tar.xz`<br/>
4. Add the flutter tool to your path:<br/>
```export PATH=$PATH:`pwd`/flutter/bin```<br/>
*Note:* The above command sets your PATH temporarily, for the current terminal session. To permanently add Flutter to your path, see [Set your path](#set-your-path)
5. Run flutter doctor:<br/>
`flutter doctor [-v]`<br/>
This command checks your environment and displays a report to the terminal window. The Dart SDK is bundled with Flutter; it is not necessary to install Dart separately. Check the output carefully for other software you may need to install or further tasks to perform.<br/><br/>

### Set your path
If you want to run Flutter in any terminal session, you need to update PATH variable permanently. The steps for modifying this variable permanently for all terminal sessions are machine-specific. Typically you add a line to a file that is executed whenever you open a new window. For example:<br/>
1. Determine the directory where you placed the Flutter SDK. You will need this in Step 3.
2. Open (or create) `$HOME/.bash_profile`. The file path and filename might be different on your machine.
3. Add the following line and change `[PATH_TO_FLUTTER_GIT_DIRECTORY]` to be the path where you cloned Flutter’s git repo:<br/>
`export PATH=$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin`
4. Run `source $HOME/.bash_profile` to refresh the current window.
5. Verify that the flutter/bin directory is now in your PATH by running:
`echo $PATH`
