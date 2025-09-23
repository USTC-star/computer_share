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
     .Height "t_pec" 
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
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "18"

'@ pick center point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickCenterpointFromId "Wilkinson PD-odb(PCB1)/Substrates:DIELECTRIC", "12"

'@ align wcs with point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ align wcs with face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.AlignWCSWithSelected "Face"

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "18"

'@ define port: 1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "True"
     .ClipPickedPortToBound "False"
     .Xrange "5769.800000092", "5769.800000092"
     .Yrange "-3076.030858265", "-3032.2307680204"
     .Zrange "0", "1.38"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "32", "32"
     .ZrangeAdd "20", "20"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ define material: Rogers RO4350B LoPro (loss free)

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Material 
     .Reset 
     .Name "Rogers RO4350B LoPro (loss free)"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.62"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .UseEmissivity "True"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .Absorptance "0"
     .MechanicsType "Unused"
     .IntrinsicCarrierDensity "0"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "3.48"
     .Mu "1.0"
     .Sigma "0.0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "1st Order"
     .DispersiveFittingSchemeMu "1st Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.75", "0.95", "0.85" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material colour: Rogers RO4350B LoPro (loss free)

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Material 
     .Name "Rogers RO4350B LoPro (loss free)"
     .Folder ""
     .Colour "0.75", "0.95", "0.85" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "244"

'@ define port: 2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Port 
     .Reset 
     .PortNumber "2" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "True"
     .ClipPickedPortToBound "False"
     .Xrange "7079.800000092", "7079.800000092"
     .Yrange "-3259.5253208826", "-3215.725278275"
     .Zrange "0", "1.38"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "32", "32"
     .ZrangeAdd "20", "20"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "4"

'@ define port: 3

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Port 
     .Reset 
     .PortNumber "3" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "True"
     .ClipPickedPortToBound "False"
     .Xrange "7079.800000092", "7079.800000092"
     .Yrange "-2892.4747216644", "-2848.6746790568"
     .Zrange "0", "1.38"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "32", "32"
     .ZrangeAdd "20", "20"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ define boundaries

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "electric"
     .Ymax "electric"
     .Zmin "open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
     .OpenAddSpaceFactor "0.5"
End With

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "308"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "392"

'@ define lumped element: Folder1:R2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LumpedElement
     .Reset 
     .SetName "R2" 
     .Folder "Folder1" 
     .SetType "RLCSerial"
     .SetR "100"
     .SetL "0"
     .SetC "0"
     .SetGs "0"
     .SetI0 "1e-14"
     .SetT "300"
     .SetMonitor "True"
     .SetRadius "0.0"
     .CircuitFileName ""
     .CircuitId "1"
     .UseCopyOnly "True"
     .UseRelativePath "False"
     .SetP1 "True", "0.69", "9.5308135399268", "-645.06818692044" 
     .SetP2 "True", "0.69", "-9.4691871939272", "-645.06818332401" 
     .SetInvert "False" 
     .Wire "" 
     .Position "end1" 
     .Create
End With

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "275"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "425"

'@ define lumped element: Folder1:R1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LumpedElement
     .Reset 
     .SetName "R1" 
     .Folder "Folder1" 
     .SetType "RLCSerial"
     .SetR "200"
     .SetL "0"
     .SetC "0"
     .SetGs "0"
     .SetI0 "1e-14"
     .SetT "300"
     .SetMonitor "True"
     .SetRadius "0.0"
     .CircuitFileName ""
     .CircuitId "1"
     .UseCopyOnly "True"
     .UseRelativePath "False"
     .SetP1 "True", "0.69", "9.4808122934396", "-940.80000002356" 
     .SetP2 "True", "0.69", "-9.4191877456578", "-940.80000002356" 
     .SetInvert "False" 
     .Wire "" 
     .Position "end1" 
     .Create
End With

'@ set 3d mesh adaptation properties

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "5" 
    .MaxPasses "16" 
    .ClearStopCriteria 
    .MaxDeltaS "0.02" 
    .NumberOfDeltaSChecks "1" 
    .EnableInnerSParameterAdaptation "True" 
    .PropagationConstantAccuracy "0.005" 
    .NumberOfPropConstChecks "2" 
    .EnablePortPropagationConstantAdaptation "True" 
    .RemoveAllUserDefinedStopCriteria 
    .AddStopCriterion "All S-Parameters", "0.02", "1", "True" 
    .AddStopCriterion "Reflection S-Parameters", "0.02", "1", "False" 
    .AddStopCriterion "Transmission S-Parameters", "0.02", "1", "False" 
    .AddStopCriterion "Portmode kz/k0", "0.005", "2", "True" 
    .AddStopCriterion "All Probes", "0.05", "2", "False" 
    .AddSParameterStopCriterion "True", "", "", "0.02", "1", "False" 
    .MinimumAcceptedCellGrowth "0.5" 
    .RefThetaFactor "" 
    .SetMinimumMeshCellGrowth "5" 
    .ErrorEstimatorType "Automatic" 
    .RefinementType "Automatic" 
    .SnapToGeometry "True" 
    .SubsequentChecksOnlyOnce "False" 
    .WavelengthBasedRefinement "True" 
    .EnableLinearGrowthLimitation "True" 
    .SetLinearGrowthLimitation "" 
    .SingularEdgeRefinement "2" 
    .DDMRefinementType "Automatic" 
End With

'@ define frequency domain solver parameters

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "True" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "False" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .SetKeepSolutionCoefficients "MonitorsAndMeshAdaptation" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.3" 
     .UseCFIEForCPECIntEq "True" 
     .UseEnhancedCFIE2 "True" 
     .UseFastRCSSweepIntEq "false" 
     .UseSensitivityAnalysis "False" 
     .UseEnhancedNFSImprint "True" 
     .UseFastDirectFFCalc "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "False" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
     .DetectThinDielectrics "True" 
End With

'@ delete lumped element: Folder1:R1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
LumpedElement.Delete "Folder1:R1"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "425"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "275"

'@ define lumped element: Folder1:R1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LumpedElement
     .Reset 
     .SetName "R1" 
     .Folder "Folder1" 
     .SetType "RLCSerial"
     .SetR "200"
     .SetL "0"
     .SetC "0"
     .SetGs "0"
     .SetI0 "1e-14"
     .SetT "300"
     .SetMonitor "True"
     .SetRadius "0.0"
     .CircuitFileName ""
     .CircuitId "1"
     .UseCopyOnly "True"
     .UseRelativePath "False"
     .SetP1 "True", "0.69", "-9.4191877456578", "-940.80000002356" 
     .SetP2 "True", "0.69", "9.4808122934396", "-940.80000002356" 
     .SetInvert "True" 
     .Wire "" 
     .Position "end1" 
     .Create
End With

'@ set 3d mesh adaptation properties

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "8" 
    .MaxPasses "16" 
    .ClearStopCriteria 
    .MaxDeltaS "0.02" 
    .NumberOfDeltaSChecks "1" 
    .EnableInnerSParameterAdaptation "True" 
    .PropagationConstantAccuracy "0.005" 
    .NumberOfPropConstChecks "2" 
    .EnablePortPropagationConstantAdaptation "True" 
    .RemoveAllUserDefinedStopCriteria 
    .AddStopCriterion "All S-Parameters", "0.02", "1", "True" 
    .AddStopCriterion "Reflection S-Parameters", "0.02", "1", "False" 
    .AddStopCriterion "Transmission S-Parameters", "0.02", "1", "False" 
    .AddStopCriterion "Portmode kz/k0", "0.005", "2", "True" 
    .AddStopCriterion "All Probes", "0.05", "2", "False" 
    .AddSParameterStopCriterion "True", "", "", "0.02", "1", "False" 
    .MinimumAcceptedCellGrowth "0.5" 
    .RefThetaFactor "" 
    .SetMinimumMeshCellGrowth "5" 
    .ErrorEstimatorType "Automatic" 
    .RefinementType "Automatic" 
    .SnapToGeometry "True" 
    .SubsequentChecksOnlyOnce "False" 
    .WavelengthBasedRefinement "True" 
    .EnableLinearGrowthLimitation "True" 
    .SetLinearGrowthLimitation "" 
    .SingularEdgeRefinement "2" 
    .DDMRefinementType "Automatic" 
End With

'@ change material and color: Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1 to: Rogers RO4350B LoPro (loss free)

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.ChangeMaterial "Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1", "Rogers RO4350B LoPro (loss free)" 
Solid.SetUseIndividualColor "Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1", 0

'@ change material and color: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU to: Copper (pure)

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.ChangeMaterial "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", "Copper (pure)" 
Solid.SetUseIndividualColor "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", 0

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ set 3d mesh adaptation properties

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "10" 
    .MaxPasses "26" 
    .ClearStopCriteria 
    .MaxDeltaS "0.02" 
    .NumberOfDeltaSChecks "1" 
    .EnableInnerSParameterAdaptation "True" 
    .PropagationConstantAccuracy "0.005" 
    .NumberOfPropConstChecks "2" 
    .EnablePortPropagationConstantAdaptation "True" 
    .RemoveAllUserDefinedStopCriteria 
    .AddStopCriterion "All S-Parameters", "0.02", "1", "True" 
    .AddStopCriterion "Reflection S-Parameters", "0.02", "1", "False" 
    .AddStopCriterion "Transmission S-Parameters", "0.02", "1", "False" 
    .AddStopCriterion "Portmode kz/k0", "0.005", "2", "True" 
    .AddStopCriterion "All Probes", "0.05", "2", "False" 
    .AddSParameterStopCriterion "True", "", "", "0.02", "1", "False" 
    .MinimumAcceptedCellGrowth "0.5" 
    .RefThetaFactor "" 
    .SetMinimumMeshCellGrowth "5" 
    .ErrorEstimatorType "Automatic" 
    .RefinementType "Automatic" 
    .SnapToGeometry "True" 
    .SubsequentChecksOnlyOnce "False" 
    .WavelengthBasedRefinement "True" 
    .EnableLinearGrowthLimitation "True" 
    .SetLinearGrowthLimitation "" 
    .SingularEdgeRefinement "2" 
    .DDMRefinementType "Automatic" 
End With

'@ delete port: port1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Port.Delete "1"

'@ delete port: port2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Port.Delete "2"

'@ delete port: port3

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Port.Delete "3"

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "18"

'@ define port: 1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "5769.800000092", "5769.800000092"
     .Yrange "-3076.030858265", "-3032.2307680204"
     .Zrange "0", "1.38"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "40", "40"
     .ZrangeAdd "22", "10"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "480"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", "251"

'@ delete lumped element: Folder1:R2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
LumpedElement.Delete "Folder1:R2"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "213"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "255"

'@ define lumped element: Folder1:R2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LumpedElement
     .Reset 
     .SetName "R2" 
     .Folder "Folder1" 
     .SetType "RLCSerial"
     .SetR "100"
     .SetL "0"
     .SetC "0"
     .SetGs "0"
     .SetI0 "1e-14"
     .SetT "300"
     .SetMonitor "True"
     .SetRadius "0.0"
     .CircuitFileName ""
     .CircuitId "1"
     .UseCopyOnly "True"
     .UseRelativePath "False"
     .SetP1 "True", "6397.4000008806", "-3044.7000002975", "1.38" 
     .SetP2 "True", "6397.4000008806", "-3063.4999996419", "1.38" 
     .SetInvert "False" 
     .Wire "" 
     .Position "end1" 
     .Create
End With

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ define material: Rogers RO4350B LoPro (loss free)

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Material 
     .Reset 
     .Name "Rogers RO4350B LoPro (loss free)"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.62"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .UseEmissivity "True"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .Absorptance "0"
     .MechanicsType "Unused"
     .IntrinsicCarrierDensity "0"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "3.44"
     .Mu "1.0"
     .Sigma "0.0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "1st Order"
     .DispersiveFittingSchemeMu "1st Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.75", "0.95", "0.85" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material colour: Rogers RO4350B LoPro (loss free)

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Material 
     .Name "Rogers RO4350B LoPro (loss free)"
     .Folder ""
     .Colour "0.75", "0.95", "0.85" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ change material and color: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):PEC to: PEC

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.SetUseIndividualColor "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):PEC", 1
Solid.ChangeIndividualColor "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):PEC", "255", "255", "0"

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ delete port: port1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "18"

'@ define port: 1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "5769.800000092", "5769.800000092"
     .Yrange "-3076.030858265", "-3032.2307680204"
     .Zrange "0", "1.38"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "6.12*20", "6.12*20"
     .ZrangeAdd "20", "6.12*20"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "4"

'@ define port: 2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Port 
     .Reset 
     .PortNumber "2" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "7079.800000092", "7079.800000092"
     .Yrange "-2892.4747216644", "-2848.6746790568"
     .Zrange "0", "1.38"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "6.12*20", "6.12*20"
     .ZrangeAdd "20", "6.12*20"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):wpd", "244"

'@ define port: 3

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Port 
     .Reset 
     .PortNumber "3" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "7079.800000092", "7079.800000092"
     .Yrange "-3259.5253208826", "-3215.725278275"
     .Zrange "0", "1.38"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "6.12*20", "6.12*20"
     .ZrangeAdd "20", "6.12*20"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ set 3d mesh adaptation properties

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "10" 
    .MaxPasses "26" 
    .ClearStopCriteria 
    .MaxDeltaS "0.02" 
    .NumberOfDeltaSChecks "1" 
    .EnableInnerSParameterAdaptation "True" 
    .PropagationConstantAccuracy "0.005" 
    .NumberOfPropConstChecks "2" 
    .EnablePortPropagationConstantAdaptation "True" 
    .RemoveAllUserDefinedStopCriteria 
    .AddStopCriterion "All S-Parameters", "0.02", "1", "True" 
    .AddStopCriterion "Reflection S-Parameters", "0.02", "1", "False" 
    .AddStopCriterion "Transmission S-Parameters", "0.02", "1", "False" 
    .AddStopCriterion "Portmode kz/k0", "0.005", "2", "True" 
    .AddStopCriterion "All Probes", "0.05", "2", "False" 
    .AddSParameterStopCriterion "True", "", "", "0.02", "1", "False" 
    .MinimumAcceptedCellGrowth "0.5" 
    .RefThetaFactor "" 
    .SetMinimumMeshCellGrowth "5" 
    .ErrorEstimatorType "Automatic" 
    .RefinementType "Automatic" 
    .SnapToGeometry "True" 
    .SubsequentChecksOnlyOnce "False" 
    .WavelengthBasedRefinement "True" 
    .EnableLinearGrowthLimitation "True" 
    .SetLinearGrowthLimitation "" 
    .SingularEdgeRefinement "2" 
    .DDMRefinementType "Automatic" 
End With

