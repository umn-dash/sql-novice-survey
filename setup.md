---
layout: page
title: Setup
---

# Overview

To participate in a Software Carpentry workshop, you will need access to software as described below. In addition, you will need an up-to-date web browser.

We maintain a list of common issues that occur during installation as a reference for instructors that may be useful on the
[Configuration Problems and Solutions wiki page](https://github.com/swcarpentry/workshop-template/wiki/Configuration-Problems-and-Solutions).

# The Bash Shell

Bash is a commonly-used shell that gives you the power to do tasks more quickly.

## Linux

The default shell is usually Bash and there is usually no need to install anything.

To see if your default shell is Bash type `echo $SHELL` in a terminal and press the **Enter** key.
If the message printed does not end with '/bash' then your default is something else and you can run Bash by typing `bash`.

## MacOS

The default shell in older versions of MacOS was `bash`. The default shell since 2019 is `zsh`, though `bash` is still available. For the purposes of
this workshop, the shells are similar enough that either is appropriate.

You access `bash` or `zsh` from the Terminal (found in `/Applications/Utilities`). See the Git installation [video tutorial](https://youtu.be/9LQhwETCdwY)
for an example on how to open the Terminal. You may want to keep Terminal in your dock for this workshop.

## Windows

* Ensure the `HOME` environment variable is set.
    * Open command prompt (Open Start Menu then type `cmd` and press **Enter**).
    * Type `echo "%USERPROFILE%"` and press **Enter**. The result displayed should be a value like `C:\Users\yourUserName`, that matches
      the path to your user (home) folder.
    * Type `echo "%HOME%"` and press **Enter**. If the result displayed matches that for `USERPROFILE`, skip the rest of these steps.
    * If `USERPROFILE` has the expected value, type `setx HOME "%USERPROFILE%"`.
    * If `USERPROFILE` does not have the expected value, set `HOME` according to the path to your use folder, e.g., `setx HOME "C:\Users\yourUserName"`.
    * Press **Enter**. The result should be something like, `SUCCESS: Specified value was saved.`
    * Quit command prompt by typing `exit` then pressing **Enter**.
* Download the [Git for Windows installer](https://gitforwindows.org/).
* Run the installer and follow the steps below.
    * Click on "Next" four times (two times if you've previously installed Git). You don't need to change anything in the Information, location, components, and start menu screens.
    * **From the dropdown menu, "Choosing the default editor used by Git", select "Use the Nano editor by default" (NOTE: you will need to scroll up to find it) and click on "Next".**
    * On the page that says "Adjusting the name of the initial branch in new repositories", ensure that "Let Git decide" is selected. This will ensure the highest level of compatibility for our lessons.
    * Ensure that "Git from the command line and also from 3rd-party software" is selected and click on "Next". (If you don't do this Git Bash will not work properly, requiring you to remove the Git Bash installation, re-run the installer and to select the "Git from the command line and also from 3rd-party software" option.)
    * Select "Use bundled OpenSSH".
    * Ensure that "Use the native Windows Secure Channel Library" is selected and click on "Next".
    * Ensure that "Checkout Windows-style, commit Unix-style line endings" is selected and click on "Next".
    * **Ensure that "Use Windows' default console window" is selected and click on "Next".**
    * Ensure that "Default (fast-forward or merge) is selected and click "Next"
    * Ensure that "Git Credential Manager" is selected and click on "Next".
    * Ensure that "Enable file system caching" is selected and click on "Next".
    * Click on "Install".
    * Click on "Finish" or "Next".

This will provide you with both Git and Bash in the Git Bash program.

# SQLite

SQL is a specialized programming language used with databases. We use a database manager called [SQLite](https://www.sqlite.org/) in our lessons.

## Linux

SQLite comes pre-installed on Linux.

## MacOS

SQLite comes pre-installed on MacOS.

## Windows

* Run "Git Bash" from the Start menu
* Copy the following: `curl -fsSL https://umn-dash.github.io/2023-09-20-umn/getsql.sh | bash`
* Paste it into the window that Git Bash opened. If you're unsure, ask an instructor for help.
* You should see something like `3.27.2 2019-02-25 16:06:06 ...`

If you want to do this manually, download [sqlite3](https://www.sqlite.org/2019/sqlite-tools-win32-x86-3270200.zip), make a `bin` directory in the
user's home directory, unzip sqlite3, move it into the `bin` directory, and then add the `bin` directory to the path.

**If you installed Anaconda, it also has a copy of SQLite [without support for `readline`](https://github.com/ContinuumIO/anaconda-issues/issues/307).
Instructors will provide a workaround for it if needed.**

## Database File

For each database instance, SQLite stores the data in a single file. Please [download survey.db](https://umn-dash.github.io/sql-novice-survey/files/survey.db),
the database we will use in this workshop.

## JupyterHub

If you have trouble setting up your own machine, we will have a fully online JupyterHub option available for all UMN users with a valid UMN login:
https://notebooks.latis.umn.edu/ Log in with UMN internet ID and password, then select “SWC - SQL” from the server choices. No need to do anything else.
All the necessary files and software are already there.
