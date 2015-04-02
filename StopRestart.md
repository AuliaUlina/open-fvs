Nick Crookston - January 2012

# FVS Stop and Restart #

## Introduction ##

FVS has the capability to stop a simulation at a selected point, store the current state variables, and then restart from where it left off. Other programs can be run in the interim. This is useful, say, in the case where FVS is used in conjunction with another model that represents some landscape-level process like fire spread. The development of all the stands in the landscape can be projected up to a stopping point while storing summaries of conditions in each stand in a data base. The separate program representing fire would be run with its output stored in separate data tables. When FVS is restarted, it can reload the state variables of each stand in turn, fetch the information left behind by the separate models, and use that information in predicting future stand development.

Achievement of this goal uses a stop-point and restart capability. Users control this capability with command line options. To create a stopping point, a tag is specified that defines where during the sequence of calculations FVS should stop, a year is specified given that defines the timing of stopping point, and a file name is specified that defines a mass storage location for all the state variables (in the future, this may be tag specifying an alternative storage method that serves the same purpose).

To restart the program, a user simply specifies the name of the mass storage where all the data were stored. FVS loads these data one stand at a time and continues the simulation of each. Note that a new stop point can be created during the processing of an existing one. Therefore, one can start the model, run for a short time, stop, restart, stop again, and repeat until the simulation is complete. In this way, the simulation can progress through time for all the stands together. Without the use of these techniques, each stand is run for the entire simulation period, independently of the others.

When FVS is run as a shared library, there is an additional stop point and restart capability. In this situation, FVS returns control to the calling program from selected stopping points within a time step without storing state variables in mass storage. In this situation, a single stand is held in computer memory (only one stand is allowed at a time) after the program returns control to the parent. When FVS is called again, it picks up where it left off with the same stand and simulates it forward to the next stop point. This can be done frequently during a simulation. In the interim, between when FVS returns and when it is called again, data within FVS can be fetched from the computer's memory and changed by the parent program. For example, alternative growth equations can be used for some of the trees or newly established trees as predicted by an independent regeneration establishment model can be added to the simulation.

These two approaches can be used together. That is, the ability to stop, store, and restart from a mass storage can be used in the same simulation as the second approach of stop and restart without storage.

FVS users may remember that the idea of stopping and restarting FVS is an old one, first introduced by Crookston and Stage in 1991 as part of the [Parallel Processing Extension of FVS (PPE)](http://www.fs.fed.us/fmsc/ftp/fvs/docs/gtr/parallel_processing.pdf). Indeed, the PPE is still available from the [Forest Management Service Center](http://www.fs.fed.us/fmsc/fvs), and the source files are in the open-fvs repository. However, the start and restart capability described here is intended to replace the PPE so that it can be retired.

## Controlling these Features ##

When FVS is run as a program, rather than being called as a shared library, the only stop and restart approach that makes sense is the first one, where the data are stored in a persistent mass storage location. [Command line](FVSCommandLine.md) options are used to control the behavior of FVS when this capability is used.

When FVS is run as a shared library both start and restart approaches can be used together. Controlling the programs behavior is done with [FVS\_API](FVS_API.md) calls that request that stop points be set and respected by FVS.

## Processing Steps ##

The two start and restart approaches are seemingly very similar, yet to use them effectively requires a clear understanding of how they work. Detecting that a stop point has been reached inside the program follows the same rules regardless of the approach.

First some terms to help the discussion. The compound word `stopWithStore` is used to refer to the first method and `stopWithoutStore` is used to refer to the second.

### Detecting the Stop Point ###

The stopping point is defined by two values. The first defines the location within the simulation where the stop point is requested and the second defines the time point during a simulation. During the processing, FVS checks to see if it has reached a stop point and if it has it takes the appropriate action. The time point is a _year_; the rule is that if the year is within the current cycle, then the stop year has been reached. The stop points are numeric codes as itemized in the [command line documentation](FVSCommandLine.md) that specify the location within the simulation steps where the stop is to occur.

### With Storing ###

#### FVS as a Program ####

When a stop point is detected the program stores the stand state data and then it moves on to the next stand. If the input is the keyword file, then the keyword file is read. Processing stops when end-of-file or the `Stop` keyword is reached. When the input is a previously stored file, processing stops when end-of-file is reached.

#### FVS as a Shared Library ####

When a stop point is detected the program stores the stand state data and returns. When FVS is called again, it moves on to the next stand. If the input is the keyword file, then the keyword file is read and processing returns when another stop point is reached. If the input is a previously stored file, FVS returns control immediately after the stand is loaded. This deserves repeating. FVS always returns after a stand is stored and before the next one is loaded, regardless of the source of the input. If the next stand is loaded from the keyword file, FVS does not return until another stop point is reached, otherwise it returns immediately after the stand is loaded. This seemingly subtle difference in behavior complicates the use of FVS in the shared library context. [FVS\_API](FVS_API.md) functions are provided that can be used to inquire as to the state of FVS.

### Without Storing ###

Use of `stopWithoutStore` only makes sense in the context of running FVS as a shared library. The processing is as follows: FVS checks to see if it has reached a stopping point using the same logic as specified for `stopWithStore` except that it uses different copies of the stop point code and stop point year to determine if the stop point has been reached. If it has been reached, FVS returns control to the calling program. When FVS is called again, it simply picks up the calculations where it left off during the simulation of the same stand. Note that the `stopWithoutStore` parameter values are specified using [FVS\_API](FVS_API.md) calls and not on the command line.

The two styles of stopping are independent of each other and can be used together in the same simulation.