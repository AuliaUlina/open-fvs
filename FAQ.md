This is a basic list of the frequently asked questions (FAQ) for the open-fvs project.

# Question 1. How do I obtain the source code? #

You can checkout the source code anonymously using [Subversion](http://subversion.apache.org/),

```
svn checkout https://open-fvs.googlecode.com/svn open-fvs
```

For more information, see the [DownloadingSourceCode](DownloadingSourceCode.md) page.

# Question 2. How do I build one of the FVS variants? #

We currently have wiki documents describing the build process on [Unix-alike](BuildProcess_UnixAlike.md) systems, and on Windows systems using [Visual Studio](BuildProcess_VisualStudio.md), [MinGW](BuildProcess_MinGW.md), or [Rtools](BuildProcess_Rtools.md).

Builds may be possible on other operating systems or with other compiler packages, but the processes are not documented here.

# Question 3. The build didn't work. Now what? #

If your build doesn't work, that is to say, you don't get an executable on your machine, attempt to build again and redirect the make output to a debugging file:

```
make FVS[variant] > FVS[variant]-make-output.txt 2>&1
```

You will also need to provide the operating system, which can be obtained using the output from the `uname -a` command for non-Windows platforms:

```
uname -a
Darwin macbook.local 10.8.0 Darwin Kernel Version 10.8.0: Tue Jun  7 16:32:41 PDT 2011; root:xnu-1504.15.3~1/RELEASE_X86_64 x86_64
```

and the `ver` command if you're using Windows:

```
C:\open-fvs\trunk\bin>ver

Microsoft Windows XP [Version 5.1.2600]

C:\open-fvs\trunk\bin>
```

Once you have those two outputs, submit your problem as a new [issue](http://code.google.com/p/open-fvs/issues/entry).

# Question 4. How do I get help if I encounter problems? #

The [Issues](http://code.google.com/p/open-fvs/issues/list) tab in the open-fvs site has a utility for submitting issues. When submitting an issue include as much detail as possible, including the specific operating system (including the version) you are using. Refer to Question 3 for directions on getting operating system information. The FVS development team will attempt to resolve your issue.

# Question 5. Where can I get production release versions of the executables? #

All of the FVS executables for Windows are avaialable from the [FVS website](http://www.fs.fed.us/fmsc/fvs/). They are distributed in an installation package that contains all of the FVS variant executables. Executables for other operating systems are not currently distributed.

# Question 6. Where can I get documentation on the models used in the FVS code? #

The FVS Variant Overviews, which are available from the [FVS website](http://www.fs.fed.us/fmsc/fvs/documents/userguides.shtml), contain information and references related to the underlying models.  The [Essential FVS](http://www.fs.fed.us/fmsc/ftp/fvs/docs/gtr/EssentialFVS.pdf) document contains a great deal of more general model documentation.

# Question 7. How do I make a new variant? #

The instructions for creating a new variant based on the code from an existing variant are found in the [MakeNewFVSProgram](http://code.google.com/p/open-fvs/wiki/MakeNewFVSProgram) wiki.