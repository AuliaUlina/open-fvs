﻿Option Strict On
Option Explicit On
Imports FVS

Public Class Testing

   Private Sub ButtonCallFORTRAN_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonCallFORTRAN.Click

      Dim fvs As New FVS_API
      Dim i As Integer
      Dim ReturnCode As Integer
      Dim RC As Integer ' another return code
      Dim rc1 As Integer
      Dim rc2 As Integer
      Dim nTrees As Integer
      Dim nCycles As Integer
      Dim nPlots As Integer
      Dim MaxTrees As Integer
      Dim MaxSpecies As Integer
      Dim MaxPlots As Integer
      Dim MaxCycles As Integer

      Dim FVSCode As String = Nothing
      Dim FIACode As String = Nothing
      Dim PlantCode As String = Nothing

      Dim Summry(19) As Integer ' 0:19 = 20
      Dim iCycle As Integer
      Dim MaxRow As Integer
      Dim MaxCol As Integer

      Dim KeywordFilename As String = ""
      Dim StandID As String = ""
      Dim CNID As String = ""
      Dim mID As String = ""

      ' Units will be metric for Summary and other I/O calls
      fvs.MeasurementUnits = "metric"

      ' Get some basic FVS array sizes prior to running
      fvs.DimSizes(nTrees, nCycles, nPlots, MaxTrees, MaxSpecies, MaxPlots, MaxCycles)

      ' Get the 3 kinds of species labels
      For i = 1 To MaxSpecies
         fvs.SpeciesCode(FVSCode, FIACode, PlantCode, i, ReturnCode)
      Next i

      ' Set the command line and stopping point
      fvs.SetCmdLine("--keywordfile=MgmtBC.key --stoppoint=1,2020,test.stop", ReturnCode)

      ' Run loop of stand and Inspect the current summary table at Cycle 2 (empty before running)
      Do
         ' fetch Stand ID and keyword filename
         fvs.StandID(StandID, CNID, mID)
         fvs.GetKeywordFilename(KeywordFilename)

         ' iterate through the stand(s) in the key file
         fvs.RunFVS(ReturnCode)

         ' inspect the error code
         fvs.GetICCode(RC)

         ' get and fetch set some other codes
         fvs.GetRestartCode(RC)
         fvs.GetStopPointCodes(rc1, rc2)
         fvs.SetStopPointCodes(rc1, rc2)

         ' fetch the 'Scen1' stand summary table for Cycle 2
         ' get some attributes and do simple manipulation of the treelist.
         If (StandID = "Scen1") Then
            iCycle = 2
            fvs.Summary(Summry, iCycle, nCycles, MaxRow, MaxCol, RC)
            fvs.DimSizes(nTrees, nCycles, nPlots, MaxTrees, MaxSpecies, MaxPlots, MaxCycles)
            Dim Diam(nTrees - 1) As Double
            Dim TPH(nTrees - 1) As Double
            Dim Vol(nTrees - 1) As Double
            fvs.TreeAttr("dbh", "get", nTrees, Diam, RC)
            fvs.TreeAttr("tpa", "get", nTrees, TPH, RC)
            fvs.TreeAttr("tcuft", "get", nTrees, Vol, RC)

            ' reduce TPH by 10%
            For i = 0 To nTrees - 1
               TPH(i) *= 0.9D
            Next i
            fvs.TreeAttr("tpa", "set", nTrees, TPH, RC)

         End If

      Loop Until ReturnCode <> 0

      fvs.SetCmdLine("--restart=test.stop", ReturnCode)
      Do
         fvs.RunFVS(ReturnCode)
      Loop Until ReturnCode <> 0

      fvs.Summary(Summry, iCycle, nCycles, MaxRow, MaxCol, ReturnCode)

   End Sub

End Class
