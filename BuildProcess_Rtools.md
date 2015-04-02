# The Build Process Using Rtools (Windows only) #

Rtools provides a single set of tools that includes everything you need to build FVS on Windows. This document describes the process of setting things up so you can use the Rtools toolkit to build FVS executables from the source files in the open-fvs repository. Furthermore this set of tools is used to develop and test the rFVS interface. For more information on the build process, including information for other compiler tools please refer to the other [build process wikis](http://code.google.com/p/open-fvs/w/list) or the [FAQ](FAQ.md) wiki.

## Getting The Necessary Tools ##

You will need the appropriate permissions (e.g., Administrator privileges in Windows) to install the necessary tools, so ensure you have that before proceeding.

There are several different compiler packages that can be used to build the executables.  The **Rtools** toolkit package will be discussed here.  Refer to the appropriate wiki document for discussion of the others. Download the Rtools toolkit from http://cran.r-project.org/bin/windows/Rtools/. You will want to download the _latest_ Rtools package, or if you are an R user, get the version that corresponds to your version of R.

Once you get the installer downloaded, run it.  Include all Components and any Additional Tasks. Then just click through the rest of the installation. Unfortunately, when the installation is complete you may not see a program icon like those typically added with an installation.

To test for successful installation of RTools you will need to open a Command Window. For example, on Windows this is done by clicking **Start > (All) Programs > Accessories > Command Prompt**.

FVS requires C-language and Fortran compilers. If you have correctly installed Rtools, everything you need will be ready for you to use. To test that you have the compilers installed, you can enter these commands from the command prompt.

At the prompt, enter the command
```
gcc --version
```
The report resulting from this command should be similar to that shown below.
```
gcc (GCC) 4.6.3 20111208 (prerelease)
Copyright (C) 2011 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```
Make sure the version shown on the first line of the report is at least 4.2.

At the prompt, enter the command
```
gfortran --version
```
The report resulting from this command should be similar to that shown below.
```
GNU Fortran (GCC) 4.6.3 20111208 (prerelease)
Copyright (C) 2011 Free Software Foundation, Inc.

GNU Fortran comes with NO WARRANTY, to the extent permitted by law.
You may redistribute copies of GNU Fortran
under the terms of the GNU General Public License.
For more information about these matters, see the file named COPYING'
```
Make sure the version shown on the first line of the report is at least 4.5.

That's it. You’ve successfully installed Rtools and can now build open-fvs programs.
Now that you have verified you have successfully installed RTools, the next step is to check out the source code from the Subversion repository located on google.code servers.

## Getting The Source Files ##

The open-fvs files are stored in a Subversion (SVN) repository. You will need SVN client software to download the files. Refer to the [DownloadingSourceCode](DownloadingSourceCode.md) wiki document for detailed downloading instructions.

## Building The Executable ##

Open a Command Window. If you don't know how to do this, refer to the "Getting the Necessary Tools" section above.

Use the `cd` command to navigate to the `trunk/bin` directory inside the directory into which you checked out the open-fvs files. If you had placed the files into a directory called `MyFvsFiles` you would type the command as shown below.  Please note that the Windows operating system requires a backslash (\) instead of a forward slash (/) to separate directory names.  Use whatever is appropriate for your operating system.


```
cd \MyFvsFiles\trunk\bin
```

Once you have navigated to the correct directory you are ready to make an executable. The FVS variant executables are named `FVS__`, where the `__` is the 2-letter abbreviation for the variant (e.g., `ie` for Inland Empire or `ls` for Lake States) optionally followed by the 1-letter abbreviation for an extension (e.g., `x` for the insect and disease extensions, or `c` for the climate extension). Executables on Windows have the filename extension `.exe` added to the base name. To make an executable, type the command `make FVS__` (or `make FVS__.exe`) with `__` replaced by the variant and extension designations. For example, to build the Inland Empire variant with the Climate extension you would use the appropriate command shown below.

On Windows (see other wiki pages for non-windows builds)
```
make FVSiec.exe
```

To build the Lake States variant with none of the optional extensions you would use the same command with "iec" replaced with "ls", as shown below.

```
make FVSls.exe
```

The variant executable file is created in the `trunk/bin` directory in which you are currently working.

A sourcelist file needs to exist in the `trunk/bin` directory in order to build the variants in this way. For example, the file `FVSls_sourceList.txt` allows you to use the `make` command to build the variant executable `FVSls` (`FVSls.exe` on Windows). Look in the `trunk/bin` directory to see which variants are currently available.

To build all of the variants for which a sourcelist file exists just type `make` and do not specify a variant. This could take a long time (up to half an hour or more) to complete.

```
make
```

To remove all the programs, object files, and build directories, use the "clean" option.

```
make clean
```

If the make command does not work, you may have a PATH issue. Right-click the My Computer icon on the Windows desktop and select Properties. Click the Advanced tab, then the Environment Variables button. Locate PATH or Path from either the User variables or System variables, then click edit. At the end of the current set of PATH directories add ";c:\Rtools\bin; c:\Rtools\gcc-4.6.3\bin". Then click OK buttons until you get back to the desktop.