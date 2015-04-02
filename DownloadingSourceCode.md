**Contents**



# Introduction #

The Forest Vegetation Simulator (FVS) code is comprised of thousands of source files housed in dozens of directories. Trying to understand the code can be intimidating and confusing, but obtaining the code and building the executables is relatively simple if you follow the instructions in the appropriate wiki pages. This wiki focuses on obtaining the code.

The open-fvs file repository is an open-source Subversion (SVN) repository. Anyone can download the source files, but you will need SVN client software in order to do it. There are very brief download instructions on the [Source](http://code.google.com/p/open-fvs/source/checkout) page of this repository, but they are suitable only for those familiar with command-line Subversion downloads.  The information below provides much more detail.

# SVN Client Software #

There are two styles of SVN client software.  The first is a command-line style that runs from a command prompt where the user types in commands.  The other uses a graphical user interface (GUI) with graphical elements like buttons and text boxes. You will have to choose SVN client software that you are comfortable with. Unless you are familiar with your command console (e.g., the DOS or UNIX console) and its associated standard commands you may want to try a GUI-based client.

There is a wide variety of SVN client software packages for different operating systems available as free downloads from http://subversion.apache.org/packages.html. Two more free packages for Windows are Tortoise (http://tortoisesvn.net) and SmartSVN (http://www.smartsvn.com). There are others available, and we don't endorse the use of any particular software. Whichever package you decide to use, make sure it is properly installed before proceeding.

# Downloading The Source Files #

In SVN terminology, downloading the source files to create a local copy of the repository is called a "checkout". You will use the checkout feature of your SVN client software package to download the FVS source files. Refer to the documentation for your particular client software if you need help with this.

Before you download the source files you will need to select or create an appropriate directory on your hard drive into which the files will be checked out. For example, you could create a directory called `open-fvs` (or any other name you choose) and checkout the repository into it. If a suitable directory already exists you can use that one. Whatever you choose as the destination directory it is suggested that its sole purpose be to store the FVS source files.

When you have SVN client software installed and have chosen a destination directory you are ready to begin downloading the files.

## Checkout Using a Command-Line SVN Client ##

If you have a command-line SVN client you can use the command shown below to checkout the source files. In order to do the checkout as described you will need to navigate to the directory into which you want to checkout the repository. Use the `cd` command to change directories. A username is NOT required to checkout the source files, so this command should work as shown. When typing this command don't forget to include the "s" in "https".

```
svn checkout https://open-fvs.googlecode.com/svn/ open-fvs
```

The last part of this command specifies the directory into which the repository will be checked out.  In this example we specified the directory "open-fvs". The open-fvs directory is a subdirectory of the current working directory for the command-line console. When the command executes you should get a copy of the entire open-fvs repository in the directory you specified. If you don't specify a directory the repository will be copied directly into the current working directory. It is also possible to specify a directory elsewhere by including the path to that directory.

## Checkout Using a GUI-Based SVN Client ##

If you have a GUI-based SVN client you will use the appropriate features to checkout the open-fvs repository into the folder you selected for this purpose. Refer to the documentation for your particular SVN client software if you need help with the checkout procedure.

You should specify the repository URL as shown below. When typing this URL don't forget to include the "s" in "https".

```
https://open-fvs.googlecode.com/svn
```

The directory into which you want to checkout the repository needs to be specified as well. Refer to the documentation for your particular SVN client software if you need help.  A username and password are NOT required to checkout the source files, so you should any references to such items should be left blank.

# Updating Your Copy of the Source Files #

After the initial checkout of the source code you will use the "update" feature of your SVN client to update your local copy of the repository with any changes that have been committed since your last update.

If using a command-line SVN client you can use the command shown below. It is easiest to navigate to your copy of the main repository directory so you don't have to specify it as part of the command.

```
svn update
```

If you have not navigated to the appropriate directory you will need to add the path to that directory to the end of the command shown above.

If you are using a GUI-based SVN client you will use the "update" feature, which is usually quite simple to use. Some update features are built into the directory navigation tool for the operating system. Refer to the SVN client documentation for more information.

# Committing Modified Code #

Only those designated as committers will be able to commit code changes. Rules and procedures for commits are covered in the [RepositoryMgmtPolicy](RepositoryMgmtPolicy.md) wiki. **All committers are expected to read that document and follow the rules it contains**.  There is one thing that should be mentioned here. Updates should be committed through the **https** version of the URL.  That is why it was suggested you use that URL when doing the intial checkout.

When committing updates you will be prompted for your googlecode email ID and googlecode password. This is not your normal password. It is assigned by the googlecode site. To see your password, sign in and use the link provided on the [Source](http://code.google.com/p/open-fvs/source/checkout) page to retrieve it.