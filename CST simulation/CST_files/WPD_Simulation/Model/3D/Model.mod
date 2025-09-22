'# MWS Version: Version 2024.0 - Sep 01 2023 - ACIS 33.0.1 -

'# length = mil
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 2 fmax = 5
'# created = '[VERSION]2024.0|33.0.1|20230901[/VERSION]


'@ use template: Planar Coupler & Divider.cfg

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
'set the units
With Units
    .SetUnit "Length", "mil"
    .SetUnit "Frequency", "GHz"
    .SetUnit "Voltage", "V"
    .SetUnit "Resistance", "Ohm"
    .SetUnit "Inductance", "nH"
    .SetUnit "Temperature",  "degC"
    .SetUnit "Time", "ns"
    .SetUnit "Current", "A"
    .SetUnit "Conductance", "S"
    .SetUnit "Capacitance", "pF"
End With

ThermalSolver.AmbientTemperature "0"

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "2", "5"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .Rho "1.204"
     .ThermalType "Normal"
     .ThermalConductivity "0.026"
      .SpecificHeat "1005", "J/K/kg"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "electric"
     .Xmax "electric"
     .Ymin "electric"
     .Ymax "electric"
     .Zmin "electric"
     .Zmax "electric"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "StepsPerWaveNear", "20"
     .Set "StepsPerBoxNear", "10"
     .Set "StepsPerWaveFar", "20"
     .Set "StepsPerBoxFar", "10"
     .Set "RatioLimitGeometry", "20"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "2;3.5;5"
Dim sDefineAtName As String
sDefineAtName = "2;3.5;5"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

' Define Power flow Monitors
With Monitor
    .Reset
    .Name "power ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Powerflow"
    .MonitorValue  zz_val
    .Create
End With

' Define Power loss Monitors
With Monitor
    .Reset
    .Name "loss ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Powerloss"
    .MonitorValue  zz_val
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Tet"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "Tetrahedral"
End With

'set the solver type
ChangeSolverType("HF Frequency Domain")

'----------------------------------------------------------------------------

'@ import odbpp file: C:\Users\PinJung\Desktop\computer_share\CST simulation\First Wilkinson PD\Wilkinson PD-odb.zip

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LayoutDB
     .Reset 
     .SourceFileName "C:\Users\PinJung\Desktop\computer_share\CST simulation\First Wilkinson PD\Wilkinson PD-odb.zip" 
     .LdbFileName "*Wilkinson PD-odb.ldb" 
     .PcbType "odbpp" 
     .KeepSynchronized "True" 
     .CreateDB 
     .LoadDB 
End With

''@ define extrude: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Extrude 
'     .Reset 
'     .Name "solid1" 
'     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Material "Wilkinson PD-odb(PCB1)/Copper" 
'     .Mode "Pointlist" 
'     .Height "-2240" 
'     .Twist "0.0" 
'     .Taper "0.0" 
'     .Origin "0.0", "0.0", "0.0" 
'     .Uvector "1.0", "0.0", "0.0" 
'     .Vvector "0.0", "1.0", "0.0" 
'     .Point "6420", "-3080" 
'     .LineTo "6480", "-3200" 
'     .LineTo "6580", "-3060" 
'     .LineTo "6420", "-3080" 
'     .Create 
'End With
'
''@ delete shape: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Delete "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1"
'
''@ split shape: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.SplitShape "02_F.CU", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)"
'
''@ define extrude: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Extrude 
'     .Reset 
'     .Name "solid1" 
'     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Material "Wilkinson PD-odb(PCB1)/Copper" 
'     .Mode "Pointlist" 
'     .Height "-640" 
'     .Twist "0.0" 
'     .Taper "0.0" 
'     .Origin "0.0", "0.0", "0.0" 
'     .Uvector "1.0", "0.0", "0.0" 
'     .Vvector "0.0", "1.0", "0.0" 
'     .Point "6060", "-3020" 
'     .LineTo "5760", "-3240" 
'     .LineTo "6160", "-3160" 
'     .LineTo "6060", "-3020" 
'     .Create 
'End With
'
''@ delete shape: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Delete "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1"
'
''@ pick face
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", "1"
'
''@ define extrude: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Extrude 
'     .Reset 
'     .Name "solid1" 
'     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Material "Wilkinson PD-odb(PCB1)/Copper" 
'     .Mode "Picks" 
'     .Height "1.3" 
'     .Twist "0.0" 
'     .Taper "0.0" 
'     .UsePicksForHeight "False" 
'     .DeleteBaseFaceSolid "False" 
'     .KeepMaterials "False" 
'     .ClearPickedFace "True" 
'     .Create 
'End With
'
''@ delete shape: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Delete "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1"
'
''@ pick face
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", "1"
'
''@ define extrude: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Extrude 
'     .Reset 
'     .Name "solid1" 
'     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Material "Wilkinson PD-odb(PCB1)/Copper" 
'     .Mode "Picks" 
'     .Height "copper_thickness" 
'     .Twist "0.0" 
'     .Taper "0.0" 
'     .UsePicksForHeight "False" 
'     .DeleteBaseFaceSolid "False" 
'     .KeepMaterials "False" 
'     .ClearPickedFace "True" 
'     .Create 
'End With
'
''@ pick face
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1", "6"
'
''@ unpick face
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.UnpickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1", "6"
'
''@ delete shape: Wilkinson PD-odb(PCB1)/Substrates:05_B.MASK
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Delete "Wilkinson PD-odb(PCB1)/Substrates:05_B.MASK"
'
''@ delete shape: Wilkinson PD-odb(PCB1)/Substrates:01_F.MASK
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Delete "Wilkinson PD-odb(PCB1)/Substrates:01_F.MASK"
'
''@ delete group: Wilkinson PD-odb(PCB1)/Layers:01_F.MASK
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Group.Delete "Wilkinson PD-odb(PCB1)/Layers:01_F.MASK"
'
''@ pick face
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1", "1"
'
''@ define extrude: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Extrude 
'     .Reset 
'     .Name "solid2" 
'     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Material "Wilkinson PD-odb(PCB1)/Copper" 
'     .Mode "Picks" 
'     .Height "-20" 
'     .Twist "0.0" 
'     .Taper "0.0" 
'     .UsePicksForHeight "False" 
'     .DeleteBaseFaceSolid "False" 
'     .KeepMaterials "False" 
'     .ClearPickedFace "True" 
'     .Create 
'End With
'
''@ change material and color: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2 to: Wilkinson PD-odb(PCB1)/FR4
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.ChangeMaterial "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2", "Wilkinson PD-odb(PCB1)/FR4" 
'Solid.SetUseIndividualColor "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2", 1
'Solid.ChangeIndividualColor "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2", "0", "85", "0"
'
''@ define material: Rogers RO4350B (loss free)
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Material
'     .Reset
'     .Name "Rogers RO4350B (loss free)"
'     .Folder ""
'     .FrqType "all"
'     .Type "Normal"
'     .SetMaterialUnit "GHz", "mm"
'     .Epsilon "3.66"
'     .Mu "1.0"
'     .Kappa "0.0"
'     .TanD "0.0"
'     .TanDFreq "0.0"
'     .TanDGiven "False"
'     .TanDModel "ConstTanD"
'     .KappaM "0.0"
'     .TanDM "0.0"
'     .TanDMFreq "0.0"
'     .TanDMGiven "False"
'     .TanDMModel "ConstKappa"
'     .DispModelEps "None"
'     .DispModelMu "None"
'     .DispersiveFittingSchemeEps "General 1st"
'     .DispersiveFittingSchemeMu "General 1st"
'     .UseGeneralDispersionEps "False"
'     .UseGeneralDispersionMu "False"
'     .Rho "0.0"
'     .ThermalType "Normal"
'     .ThermalConductivity "0.69"
'     .SetActiveMaterial "all"
'     .Colour "0.75", "0.95", "0.85"
'     .Wireframe "False"
'     .Transparency "0"
'     .Create
'End With
'
''@ change material: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2 to: Rogers RO4350B (loss free)
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.ChangeMaterial "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2", "Rogers RO4350B (loss free)"
'
''@ define material: Dielectric
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Material
'.Reset
'.Name "Dielectric"
'.Folder ""
'.Type "Normal"
'.Epsilon "3.8"
'.Create
'End With
'
''@ new component: Thin Microstrip
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Component.New "Thin Microstrip"
'
''@ define brick: Thin Microstrip:Trace
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Brick
'.Reset
'.Name "Trace"
'.Component "Thin Microstrip"
'.Material "PEC"
'.Xrange "-40/2", "40/2"
'.Yrange "0", "0"
'.Zrange "-1.0000e+00/2", "1.0000e+00/2"
'.Create
'End With
'
''@ define brick: Thin Microstrip:Substrate
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Brick
'.Reset
'.Name "Substrate"
'.Component "Thin Microstrip"
'.Material "Dielectric"
'.Xrange "-240/2", "240/2"
'.Yrange "-20", "0"
'.Zrange "-1.0000e+00/2", "1.0000e+00/2"
'.Create
'End With
'
''@ define brick: Thin Microstrip:Ground
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Brick
'.Reset
'.Name "Ground"
'.Component "Thin Microstrip"
'.Material "PEC"
'.Xrange "-240/2", "240/2"
'.Yrange "-0-20", "-20"
'.Zrange "-1.0000e+00/2", "1.0000e+00/2"
'.Create
'End With
'
''@ pick mid point
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1", "647"
'
''@ activate local coordinates
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'WCS.ActivateWCS "local"
'
''@ rename block: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1 to: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Rename "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1", "WPD"
'
''@ rename block: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD to: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Rename "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD", "Substrate"
'
''@ activate global coordinates
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'WCS.ActivateWCS "global"
'
''@ transform: translate Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Transform 
'     .Reset 
'     .Name "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate" 
'     .Vector "-20", "0", "0" 
'     .UsePickedPoints "False" 
'     .InvertPickedPoints "False" 
'     .MultipleObjects "False" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Translate" 
'End With
'
''@ pick mid point
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate", "647"
'
''@ delete component: Thin Microstrip
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Component.Delete "Thin Microstrip"
'
''@ activate local coordinates
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'WCS.ActivateWCS "local"
'
''@ transform: translate Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Transform 
'     .Reset 
'     .Name "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Vector "-6400", "0", "0" 
'     .UsePickedPoints "False" 
'     .InvertPickedPoints "False" 
'     .MultipleObjects "False" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Translate" 
'End With
'
''@ remove items from group: "Wilkinson PD-odb(PCB1)/Layers:03_DIELECTRIC_1"
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Group.RemoveItem "solid$Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1", "Wilkinson PD-odb(PCB1)/Layers:03_DIELECTRIC_1"
'
''@ delete group: Wilkinson PD-odb(PCB1)/Layers:03_DIELECTRIC_1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Group.Delete "Wilkinson PD-odb(PCB1)/Layers:03_DIELECTRIC_1"
'
''@ delete group: Wilkinson PD-odb(PCB1)/Layers:05_B.MASK
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Group.Delete "Wilkinson PD-odb(PCB1)/Layers:05_B.MASK"
'
''@ delete shape: Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Delete "Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1"
'
''@ transform: translate Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Transform 
'     .Reset 
'     .Name "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Vector "0", "3100", "0" 
'     .UsePickedPoints "False" 
'     .InvertPickedPoints "False" 
'     .MultipleObjects "False" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Translate" 
'End With
'
''@ rename block: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate to: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Rename "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate", "WPD"
'
''@ rename block: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2 to: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Rename "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2", "Substrate"
'
''@ pick face
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD", "223"
'
''@ define brick: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid1" 
'     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Material "Vacuum" 
'     .Xrange "680", "900" 
'     .Yrange "-700", "700" 
'     .Zrange "-60", "60" 
'     .Create
'End With
'
''@ boolean insert shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Solid
'     .Version 10
'     .Insert "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate" 
'     .Version 1
'End With
'
''@ boolean insert shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Solid
'     .Version 10
'     .Insert "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD" 
'     .Version 1
'End With
'
''@ boolean subtract shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Subtract "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD"
'
''@ boolean subtract shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Subtract "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1"
'
''@ pick face
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", "1"
'
''@ define extrude: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Extrude 
'     .Reset 
'     .Name "solid1" 
'     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Material "Wilkinson PD-odb(PCB1)/Copper" 
'     .Mode "Picks" 
'     .Height "copper_thickness" 
'     .Twist "0.0" 
'     .Taper "0.0" 
'     .UsePicksForHeight "False" 
'     .DeleteBaseFaceSolid "False" 
'     .KeepMaterials "True" 
'     .ClearPickedFace "True" 
'     .Create 
'End With
'
''@ rename block: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1 to: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Rename "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1", "WPD"
'
''@ define curve rectangle: curve1:rectangle1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Rectangle
'     .Reset 
'     .Name "rectangle1" 
'     .Curve "curve1" 
'     .Xrange "-760", "-640" 
'     .Yrange "-580", "580" 
'     .Create
'End With
'
'
''@ delete curve: curve1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Curve.DeleteCurve "curve1"
'
''@ define extrude: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Extrude 
'     .Reset 
'     .Name "solid1" 
'     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Material "Wilkinson PD-odb(PCB1)/Copper" 
'     .Mode "Pointlist" 
'     .Height "800" 
'     .Twist "0.0" 
'     .Taper "0.0" 
'     .Origin "0.0", "0.0", "-400" 
'     .Uvector "1.0", "0.0", "0.0" 
'     .Vvector "0.0", "1.0", "0.0" 
'     .Point "-640", "460" 
'     .LineTo "-640", "-460" 
'     .LineTo "-750", "-460" 
'     .LineTo "-750", "460" 
'     .Create 
'End With
'
''@ boolean subtract shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Subtract "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1"
'
''@ delete shape: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Delete "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU"
'
''@ define brick: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid1" 
'     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Material "Wilkinson PD-odb(PCB1)/Copper" 
'     .Xrange "670", "800" 
'     .Yrange "-320", "440" 
'     .Zrange "-160", "160" 
'     .Create
'End With
'
''@ boolean subtract shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Subtract "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1"
'
''@ pick face
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate", "235"
'
''@ define extrude: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):PEC
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Extrude 
'     .Reset 
'     .Name "PEC" 
'     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Material "PEC" 
'     .Mode "Picks" 
'     .Height "pec_thickness" 
'     .Twist "0.0" 
'     .Taper "0.0" 
'     .UsePicksForHeight "False" 
'     .DeleteBaseFaceSolid "False" 
'     .KeepMaterials "False" 
'     .ClearPickedFace "True" 
'     .Create 
'End With
'
''@ pick mid point
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD", "682"
'
''@ align wcs with point
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'WCS.AlignWCSWithSelected "Point"
'
''@ define brick: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid1" 
'     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Material "PEC" 
'     .Xrange "-1200", "0" 
'     .Yrange "-1500", "1500" 
'     .Zrange "-200", "200" 
'     .Create
'End With
'
''@ boolean insert shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):PEC, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Solid
'     .Version 10
'     .Insert "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):PEC", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1" 
'     .Version 1
'End With
'
''@ boolean subtract shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Subtract "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1"
'
''@ pick mid point
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD", "687"
'
''@ align wcs with point
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'WCS.AlignWCSWithSelected "Point"
'
''@ define brick: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid1" 
'     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
'     .Material "Vacuum" 
'     .Xrange "0", "300" 
'     .Yrange "-1200", "1200" 
'     .Zrange "-500", "500" 
'     .Create
'End With
'
''@ boolean insert shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):PEC, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Solid
'     .Version 10
'     .Insert "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):PEC", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1" 
'     .Version 1
'End With
'
''@ boolean subtract shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.Subtract "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1"
'
''@ change component: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD to: Wilkinson PD-odb(PCB1):WPD
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.ChangeComponent "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):WPD", "Wilkinson PD-odb(PCB1)"
'
''@ change component: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate to: Wilkinson PD-odb(PCB1):Substrate
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.ChangeComponent "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):Substrate", "Wilkinson PD-odb(PCB1)"
'
''@ change component: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):PEC to: Wilkinson PD-odb(PCB1):PEC
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.ChangeComponent "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):PEC", "Wilkinson PD-odb(PCB1)"
'
''@ delete component: Wilkinson PD-odb(PCB1)/Nets
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Component.Delete "Wilkinson PD-odb(PCB1)/Nets"
'
''@ rename material: Wilkinson PD-odb(PCB1)/Copper to: Copper
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Material.Rename "Wilkinson PD-odb(PCB1)/Copper", "Copper"
'
''@ rename material: Wilkinson PD-odb(PCB1)/FR4 to: FR4
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Material.Rename "Wilkinson PD-odb(PCB1)/FR4", "FR4"
'
''@ delete material: Wilkinson PD-odb(PCB1)/PEC Sheets
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Material.Delete "Wilkinson PD-odb(PCB1)/PEC Sheets"
'
''@ delete material: Wilkinson PD-odb(PCB1)/VIAS_MATERIAL
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Material.Delete "Wilkinson PD-odb(PCB1)/VIAS_MATERIAL"
'
''@ delete material: Wilkinson PD-odb(PCB1)
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Material.DeleteFolder "Wilkinson PD-odb(PCB1)"
'
''@ define material: Copper
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Material
'     .Reset
'     .Name "Copper"
'     .Folder ""
'     .Rho "8930"
'     .ThermalType "Normal"
'     .ThermalConductivity "401"
'     .SpecificHeat "390", "J/K/kg"
'     .DynamicViscosity "0"
'     .UseEmissivity "True"
'     .Emissivity "0"
'     .MetabolicRate "0"
'     .VoxelConvection "0"
'     .BloodFlow "0"
'     .Absorptance "0"
'     .MechanicsType "Isotropic"
'     .YoungsModulus "120"
'     .PoissonsRatio "0.33"
'     .ThermalExpansionRate "17"
'     .IntrinsicCarrierDensity "0"
'     .FrqType "all"
'     .Type "Lossy metal"
'     .MaterialUnit "Frequency", "GHz"
'     .MaterialUnit "Geometry", "mm"
'     .MaterialUnit "Time", "s"
'     .Mu "1"
'     .Sigma "5.8e+07"
'     .LossyMetalSIRoughness "0.0"
'     .ReferenceCoordSystem "Global"
'     .CoordSystemType "Cartesian"
'     .NLAnisotropy "False"
'     .NLAStackingFactor "1"
'     .NLADirectionX "1"
'     .NLADirectionY "0"
'     .NLADirectionZ "0"
'     .FrqType "static"
'     .Type "Normal"
'     .MaterialUnit "Frequency", "Hz"
'     .MaterialUnit "Geometry", "mm"
'     .MaterialUnit "Time", "s"
'     .Epsilon "1"
'     .Mu "1"
'     .Sigma "5.8e+07"
'     .TanD "0.0"
'     .TanDFreq "0.0"
'     .TanDGiven "False"
'     .TanDModel "ConstTanD"
'     .SetConstTanDStrategyEps "AutomaticOrder"
'     .ConstTanDModelOrderEps "3"
'     .DjordjevicSarkarUpperFreqEps "0"
'     .SetElParametricConductivity "False"
'     .ReferenceCoordSystem "Global"
'     .CoordSystemType "Cartesian"
'     .SigmaM "0"
'     .TanDM "0.0"
'     .TanDMFreq "0.0"
'     .TanDMGiven "False"
'     .TanDMModel "ConstTanD"
'     .SetConstTanDStrategyMu "AutomaticOrder"
'     .ConstTanDModelOrderMu "3"
'     .DjordjevicSarkarUpperFreqMu "0"
'     .SetMagParametricConductivity "False"
'     .DispModelEps  "None"
'     .DispModelMu "None"
'     .DispersiveFittingSchemeEps "Nth Order"
'     .MaximalOrderNthModelFitEps "10"
'     .ErrorLimitNthModelFitEps "0.1"
'     .DispersiveFittingSchemeMu "Nth Order"
'     .MaximalOrderNthModelFitMu "10"
'     .ErrorLimitNthModelFitMu "0.1"
'     .UseGeneralDispersionEps "False"
'     .UseGeneralDispersionMu "False"
'     .NLAnisotropy "False"
'     .NLAStackingFactor "1"
'     .NLADirectionX "1"
'     .NLADirectionY "0"
'     .NLADirectionZ "0"
'     .Colour "0.703", "0.703", "0" 
'     .Wireframe "False" 
'     .Reflection "False" 
'     .Allowoutline "True" 
'     .Transparentoutline "False" 
'     .Transparency "0" 
'     .Create
'End With
'
''@ define material: Copper (pure)
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Material
'     .Reset
'     .Name "Copper (pure)"
'     .Folder ""
'     .FrqType "all"
'     .Type "Lossy metal"
'     .MaterialUnit "Frequency", "GHz"
'     .MaterialUnit "Geometry", "mm"
'     .MaterialUnit "Time", "s"
'     .MaterialUnit "Temperature", "Kelvin"
'     .Mu "1.0"
'     .Sigma "5.96e+007"
'     .Rho "8930.0"
'     .ThermalType "Normal"
'     .ThermalConductivity "401.0"
'     .SpecificHeat "390", "J/K/kg"
'     .MetabolicRate "0"
'     .BloodFlow "0"
'     .VoxelConvection "0"
'     .MechanicsType "Isotropic"
'     .YoungsModulus "120"
'     .PoissonsRatio "0.33"
'     .ThermalExpansionRate "17"
'     .ReferenceCoordSystem "Global"
'     .CoordSystemType "Cartesian"
'     .NLAnisotropy "False"
'     .NLAStackingFactor "1"
'     .NLADirectionX "1"
'     .NLADirectionY "0"
'     .NLADirectionZ "0"
'     .FrqType "static"
'     .Type "Normal"
'     .SetMaterialUnit "Hz", "mm"
'     .Epsilon "1"
'     .Mu "1.0"
'     .Kappa "5.96e+007"
'     .TanD "0.0"
'     .TanDFreq "0.0"
'     .TanDGiven "False"
'     .TanDModel "ConstTanD"
'     .KappaM "0"
'     .TanDM "0.0"
'     .TanDMFreq "0.0"
'     .TanDMGiven "False"
'     .TanDMModel "ConstTanD"
'     .DispModelEps "None"
'     .DispModelMu "None"
'     .DispersiveFittingSchemeEps "Nth Order"
'     .DispersiveFittingSchemeMu "Nth Order"
'     .UseGeneralDispersionEps "False"
'     .UseGeneralDispersionMu "False"
'     .Colour "1", "1", "0"
'     .Wireframe "False"
'     .Reflection "False"
'     .Allowoutline "True"
'     .Transparentoutline "False"
'     .Transparency "0"
'     .Create
'End With
'
''@ define material colour: Copper
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Material 
'     .Name "Copper"
'     .Folder ""
'     .Colour "0.703", "0.703", "0" 
'     .Wireframe "False" 
'     .Reflection "False" 
'     .Allowoutline "True" 
'     .Transparentoutline "False" 
'     .Transparency "0" 
'     .ChangeColour 
'End With
'
''@ define material: Copper
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Material 
'     .Reset 
'     .Name "Copper"
'     .Folder ""
'     .Rho "8930"
'     .ThermalType "Normal"
'     .ThermalConductivity "401"
'     .SpecificHeat "390", "J/K/kg"
'     .DynamicViscosity "0"
'     .UseEmissivity "True"
'     .Emissivity "0"
'     .MetabolicRate "0"
'     .VoxelConvection "0"
'     .BloodFlow "0"
'     .Absorptance "0"
'     .MechanicsType "Isotropic"
'     .YoungsModulus "120"
'     .PoissonsRatio "0.33"
'     .ThermalExpansionRate "17"
'     .IntrinsicCarrierDensity "0"
'     .FrqType "hf"
'     .Type "Lossy metal"
'     .MaterialUnit "Frequency", "GHz"
'     .MaterialUnit "Geometry", "mm"
'     .MaterialUnit "Time", "s"
'     .Mu "1"
'     .Sigma "5.8e+07"
'     .LossyMetalSIRoughness "0.0"
'     .ReferenceCoordSystem "Global"
'     .CoordSystemType "Cartesian"
'     .NLAnisotropy "False"
'     .NLAStackingFactor "1"
'     .NLADirectionX "1"
'     .NLADirectionY "0"
'     .NLADirectionZ "0"
'     .FrqType "static"
'     .Type "Normal"
'     .MaterialUnit "Frequency", "Hz"
'     .MaterialUnit "Geometry", "mm"
'     .MaterialUnit "Time", "s"
'     .Epsilon "1"
'     .Mu "1"
'     .Sigma "5.8e+07"
'     .TanD "0.0"
'     .TanDFreq "0.0"
'     .TanDGiven "False"
'     .TanDModel "ConstTanD"
'     .SetConstTanDStrategyEps "AutomaticOrder"
'     .ConstTanDModelOrderEps "3"
'     .DjordjevicSarkarUpperFreqEps "0"
'     .SetElParametricConductivity "False"
'     .ReferenceCoordSystem "Global"
'     .CoordSystemType "Cartesian"
'     .SigmaM "0"
'     .TanDM "0.0"
'     .TanDMFreq "0.0"
'     .TanDMGiven "False"
'     .TanDMModel "ConstTanD"
'     .SetConstTanDStrategyMu "AutomaticOrder"
'     .ConstTanDModelOrderMu "3"
'     .DjordjevicSarkarUpperFreqMu "0"
'     .SetMagParametricConductivity "False"
'     .DispModelEps  "None"
'     .DispModelMu "None"
'     .DispersiveFittingSchemeEps "Nth Order"
'     .MaximalOrderNthModelFitEps "10"
'     .ErrorLimitNthModelFitEps "0.1"
'     .UseOnlyDataInSimFreqRangeNthModelEps "False"
'     .DispersiveFittingSchemeMu "Nth Order"
'     .MaximalOrderNthModelFitMu "10"
'     .ErrorLimitNthModelFitMu "0.1"
'     .UseOnlyDataInSimFreqRangeNthModelMu "False"
'     .UseGeneralDispersionEps "False"
'     .UseGeneralDispersionMu "False"
'     .NLAnisotropy "False"
'     .NLAStackingFactor "1"
'     .NLADirectionX "1"
'     .NLADirectionY "0"
'     .NLADirectionZ "0"
'     .FrqType "all"
'     .Type "Lossy metal"
'     .MaterialUnit "Frequency", "GHz"
'     .MaterialUnit "Geometry", "mm"
'     .MaterialUnit "Time", "s"
'     .Mu "1"
'     .Sigma "5.8e+07"
'     .LossyMetalSIRoughness "0.0"
'     .ReferenceCoordSystem "Global"
'     .CoordSystemType "Cartesian"
'     .NLAnisotropy "False"
'     .NLAStackingFactor "1"
'     .NLADirectionX "1"
'     .NLADirectionY "0"
'     .NLADirectionZ "0"
'     .Colour "0.703", "0.703", "0" 
'     .Wireframe "False" 
'     .Reflection "False" 
'     .Allowoutline "True" 
'     .Transparentoutline "False" 
'     .Transparency "0" 
'     .Create
'End With
'
''@ delete group: Wilkinson PD-odb(PCB1)/Layers:02_F.CU
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Group.Delete "Wilkinson PD-odb(PCB1)/Layers:02_F.CU"
'
''@ define material: Copper (pure)
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Material
'     .Reset
'     .Name "Copper (pure)"
'     .Folder ""
'     .FrqType "all"
'     .Type "Lossy metal"
'     .MaterialUnit "Frequency", "GHz"
'     .MaterialUnit "Geometry", "mm"
'     .MaterialUnit "Time", "s"
'     .MaterialUnit "Temperature", "Kelvin"
'     .Mu "1.0"
'     .Sigma "5.96e+007"
'     .Rho "8930.0"
'     .ThermalType "Normal"
'     .ThermalConductivity "401.0"
'     .SpecificHeat "390", "J/K/kg"
'     .MetabolicRate "0"
'     .BloodFlow "0"
'     .VoxelConvection "0"
'     .MechanicsType "Isotropic"
'     .YoungsModulus "120"
'     .PoissonsRatio "0.33"
'     .ThermalExpansionRate "17"
'     .ReferenceCoordSystem "Global"
'     .CoordSystemType "Cartesian"
'     .NLAnisotropy "False"
'     .NLAStackingFactor "1"
'     .NLADirectionX "1"
'     .NLADirectionY "0"
'     .NLADirectionZ "0"
'     .FrqType "static"
'     .Type "Normal"
'     .SetMaterialUnit "Hz", "mm"
'     .Epsilon "1"
'     .Mu "1.0"
'     .Kappa "5.96e+007"
'     .TanD "0.0"
'     .TanDFreq "0.0"
'     .TanDGiven "False"
'     .TanDModel "ConstTanD"
'     .KappaM "0"
'     .TanDM "0.0"
'     .TanDMFreq "0.0"
'     .TanDMGiven "False"
'     .TanDMModel "ConstTanD"
'     .DispModelEps "None"
'     .DispModelMu "None"
'     .DispersiveFittingSchemeEps "Nth Order"
'     .DispersiveFittingSchemeMu "Nth Order"
'     .UseGeneralDispersionEps "False"
'     .UseGeneralDispersionMu "False"
'     .Colour "1", "1", "0"
'     .Wireframe "False"
'     .Reflection "False"
'     .Allowoutline "True"
'     .Transparentoutline "False"
'     .Transparency "0"
'     .Create
'End With
'
''@ pick face
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickFaceFromId "Wilkinson PD-odb(PCB1):WPD", "10"
'
''@ define port:1
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient
'
'
'With Port
'  .Reset
'  .PortNumber "1"
'  .NumberOfModes "1"
'  .AdjustPolarization False
'  .PolarizationAngle "0.0"
'  .ReferencePlaneDistance "0"
'  .TextSize "50"
'  .Coordinates "Picks"
'  .Orientation "Positive"
'  .PortOnBound "True"
'  .ClipPickedPortToBound "False"
'  .XrangeAdd "0", "0"
'  .YrangeAdd "20*6.07", "20*6.07"
'  .ZrangeAdd "20", "20*6.07"
'  .Shield "PEC"
'  .SingleEnded "False"
'  .Create
'End With
'
''@ define material: Rogers RO4350B (loss free)
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Material 
'     .Reset 
'     .Name "Rogers RO4350B (loss free)"
'     .Folder ""
'     .Rho "0.0"
'     .ThermalType "Normal"
'     .ThermalConductivity "0.69"
'     .SpecificHeat "0", "J/K/kg"
'     .DynamicViscosity "0"
'     .UseEmissivity "True"
'     .Emissivity "0"
'     .MetabolicRate "0.0"
'     .VoxelConvection "0.0"
'     .BloodFlow "0"
'     .Absorptance "0"
'     .MechanicsType "Unused"
'     .IntrinsicCarrierDensity "0"
'     .FrqType "all"
'     .Type "Normal"
'     .MaterialUnit "Frequency", "GHz"
'     .MaterialUnit "Geometry", "mm"
'     .MaterialUnit "Time", "s"
'     .Epsilon "3.48"
'     .Mu "1.0"
'     .Sigma "0.0"
'     .TanD "0.0"
'     .TanDFreq "0.0"
'     .TanDGiven "False"
'     .TanDModel "ConstTanD"
'     .SetConstTanDStrategyEps "AutomaticOrder"
'     .ConstTanDModelOrderEps "3"
'     .DjordjevicSarkarUpperFreqEps "0"
'     .SetElParametricConductivity "False"
'     .ReferenceCoordSystem "Global"
'     .CoordSystemType "Cartesian"
'     .SigmaM "0.0"
'     .TanDM "0.0"
'     .TanDMFreq "0.0"
'     .TanDMGiven "False"
'     .TanDMModel "ConstTanD"
'     .SetConstTanDStrategyMu "AutomaticOrder"
'     .ConstTanDModelOrderMu "3"
'     .DjordjevicSarkarUpperFreqMu "0"
'     .SetMagParametricConductivity "False"
'     .DispModelEps  "None"
'     .DispModelMu "None"
'     .DispersiveFittingSchemeEps "1st Order"
'     .DispersiveFittingSchemeMu "1st Order"
'     .UseGeneralDispersionEps "False"
'     .UseGeneralDispersionMu "False"
'     .NLAnisotropy "False"
'     .NLAStackingFactor "1"
'     .NLADirectionX "1"
'     .NLADirectionY "0"
'     .NLADirectionZ "0"
'     .Colour "0.75", "0.95", "0.85" 
'     .Wireframe "False" 
'     .Reflection "False" 
'     .Allowoutline "True" 
'     .Transparentoutline "False" 
'     .Transparency "0" 
'     .Create
'End With
'
''@ define material colour: Rogers RO4350B (loss free)
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'With Material 
'     .Name "Rogers RO4350B (loss free)"
'     .Folder ""
'     .Colour "0.75", "0.95", "0.85" 
'     .Wireframe "False" 
'     .Reflection "False" 
'     .Allowoutline "True" 
'     .Transparentoutline "False" 
'     .Transparency "0" 
'     .ChangeColour 
'End With
'
''@ change material: Wilkinson PD-odb(PCB1):WPD to: Copper (pure)
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Solid.ChangeMaterial "Wilkinson PD-odb(PCB1):WPD", "Copper (pure)"
'
''@ delete material: Copper
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Material.Delete "Copper"
'
''@ delete material: FR4
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Material.Delete "FR4"
'
''@ pick face
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'Pick.PickFaceFromId "Wilkinson PD-odb(PCB1):WPD", "10"
'
''@ define port:2
'
''[VERSION]2024.0|33.0.1|20230901[/VERSION]
'' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient
'
'
'With Port
'  .Reset
'  .PortNumber "2"
'  .NumberOfModes "1"
'  .AdjustPolarization False
'  .PolarizationAngle "0.0"
'  .ReferencePlaneDistance "0"
'  .TextSize "50"
'  .Coordinates "Picks"
'  .Orientation "Positive"
'  .PortOnBound "True"
'  .ClipPickedPortToBound "False"
'  .XrangeAdd "0", "0"
'  .YrangeAdd "20*6.11", "20*6.11"
'  .ZrangeAdd "20", "20*6.11"
'  .Shield "PEC"
'  .SingleEnded "False"
'  .Create
'End With
'
'@ delete shape: Wilkinson PD-odb(PCB1)/Substrates:01_F.MASK

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Delete "Wilkinson PD-odb(PCB1)/Substrates:01_F.MASK"

'@ delete shape: Wilkinson PD-odb(PCB1)/Substrates:05_B.MASK

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Delete "Wilkinson PD-odb(PCB1)/Substrates:05_B.MASK"

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1", "1"

'@ define material: Rogers RO4350B LoPro (loss free)

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Material
     .Reset
     .Name "Rogers RO4350B LoPro (loss free)"
     .Folder ""
     .FrqType "all"
     .Type "Normal"
     .SetMaterialUnit "GHz", "mm"
     .Epsilon "3.55"
     .Mu "1.0"
     .Kappa "0.0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstKappa"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.62"
     .SetActiveMaterial "all"
     .Colour "0.75", "0.95", "0.85"
     .Wireframe "False"
     .Transparency "0"
     .Create
End With

'@ define extrude: Wilkinson PD-odb(PCB1)/Substrates:DIELECTRIC

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Extrude 
     .Reset 
     .Name "DIELECTRIC" 
     .Component "Wilkinson PD-odb(PCB1)/Substrates" 
     .Material "Rogers RO4350B LoPro (loss free)" 
     .Mode "Picks" 
     .Height "-sub_t" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "False" 
     .DeleteBaseFaceSolid "False" 
     .KeepMaterials "False" 
     .ClearPickedFace "True" 
     .Create 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", "1"

'@ define material: Copper (pure)

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Material
     .Reset
     .Name "Copper (pure)"
     .Folder ""
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .MaterialUnit "Temperature", "Kelvin"
     .Mu "1.0"
     .Sigma "5.96e+007"
     .Rho "8930.0"
     .ThermalType "Normal"
     .ThermalConductivity "401.0"
     .SpecificHeat "390", "J/K/kg"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "120"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "17"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .FrqType "static"
     .Type "Normal"
     .SetMaterialUnit "Hz", "mm"
     .Epsilon "1"
     .Mu "1.0"
     .Kappa "5.96e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .DispersiveFittingSchemeMu "Nth Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .Colour "1", "1", "0"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

'@ define extrude: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Extrude 
     .Reset 
     .Name "solid1" 
     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
     .Material "Copper (pure)" 
     .Mode "Picks" 
     .Height "h_wpd" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "False" 
     .DeleteBaseFaceSolid "False" 
     .KeepMaterials "False" 
     .ClearPickedFace "True" 
     .Create 
End With

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1", "314"

'@ align wcs with point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ define brick: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "solid2" 
     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
     .Material "Copper (pure)" 
     .Xrange "-440", "-320" 
     .Yrange "-680", "680" 
     .Zrange "-340", "340" 
     .Create
End With

'@ rename block: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1 to: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Rename "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1", "wpd"

'@ boolean insert shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Solid
     .Version 10
     .Insert "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2" 
     .Version 1
End With

'@ boolean insert shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Solid
     .Version 10
     .Insert "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2" 
     .Version 1
End With

'@ boolean insert shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Solid
     .Version 10
     .Insert "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2" 
     .Version 1
End With

'@ boolean insert shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Solid
     .Version 10
     .Insert "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2" 
     .Version 1
End With

'@ boolean insert shapes: Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Solid
     .Version 10
     .Insert "Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2" 
     .Version 1
End With

'@ boolean subtract shapes: Wilkinson PD-odb(PCB1)/Substrates:DIELECTRIC, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Subtract "Wilkinson PD-odb(PCB1)/Substrates:DIELECTRIC", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid2"

'@ define brick: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
     .Material "Copper (pure)" 
     .Xrange "990", "1250" 
     .Yrange "-450", "400" 
     .Zrange "-800", "800" 
     .Create
End With

'@ boolean insert shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Solid
     .Version 10
     .Insert "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1" 
     .Version 1
End With

'@ boolean insert shapes: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Solid
     .Version 10
     .Insert "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1" 
     .Version 1
End With

'@ boolean insert shapes: Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Solid
     .Version 10
     .Insert "Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1" 
     .Version 1
End With

'@ boolean subtract shapes: Wilkinson PD-odb(PCB1)/Substrates:DIELECTRIC, Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Subtract "Wilkinson PD-odb(PCB1)/Substrates:DIELECTRIC", "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):solid1"

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Substrates:DIELECTRIC", "21"

'@ define extrude: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):PEC

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Extrude 
     .Reset 
     .Name "PEC" 
     .Component "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3)" 
     .Material "PEC" 
     .Mode "Picks" 
     .Height "-t_pec" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "False" 
     .DeleteBaseFaceSolid "False" 
     .KeepMaterials "False" 
     .ClearPickedFace "True" 
     .Create 
End With

