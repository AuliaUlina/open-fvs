# Introduction #

FVS can be run by entering the program name at the system command line and then answering prompts for the names of input and output file names. These names are often given even when not used by FVS. An alternative is to use a command line option to specify the keyword file name and letting FVS create additional files as needed.

In addition, FVS can be directed to store its memory in a file at a specific point in a simulation and then stop. The program can then restart from where it left off and continue the simulation. This facility is most useful when FVS is used as a shared library (see [FVS\_API](FVS_API.md)).

# Options #

`--keywordfile=<fileNamePrefix>.key`
> Specify the input keyword file name. Note that all output files will be opened automatically using the `<fileNamePrefix>` and the suffix **must** be `.key`.  The <> characters are not included, for example if the input keyword file name is `myInputFile.key`, then the following is coded: `--keywordfile=myInputFile.key`. Specifying `--keywordfile` is not allowed if `--restart` (see below) is specified.

`--stoppoint=<stopptcode>,<stopptyear>[,<stopptfile>]`

> Specify that the program stop during the cycle that contains the _stop point year_ specified as `<stopptyear>` and that the state of the simulation is stored as of a specific point during the simulation as designated by the _stop point code_ specified as `<stopptcode>`. Prior to stopping, all the state variables associated with a stand are stored in the file called the _stop point file_ if one is specified as the `<stopptfile>`. The possible values for the stoppcode code are:

|Stop Point Code|Definition|
|:--------------|:---------|
|`0`|Don't stop.|
|`-1`|Stop at every stop point; only used with the [FVS API](FVS_API.md).|
|`1`|Stop just before the first call to the Event Monitor.|
|`2`|Stop just after the first call to the Event Monitor.|
|`3`|Stop just before the second call to the Event Monitor.|
|`4`|Stop just after the second call to the Event Monitor.|
|`5`|Stop after growth and mortality has been computed, but prior to applying them.|
|`6`|Stop just before the estab routines are called.|


Example:
```
FVSiec --keywordfile=test.key --stoppoint=1,2040,test.stop
```

`--restart=<stopptfile>`

> Specify that the program recover the state variables and continue processing from where it left off. This option may be used with `--stoppoint` but it is not allowed with `--keywordfile`.

Example:
```
FVSiec --restart=test.stop
```