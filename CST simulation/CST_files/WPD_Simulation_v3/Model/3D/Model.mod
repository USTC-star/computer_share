'# MWS Version: Version 2024.0 - Sep 01 2023 - ACIS 33.0.1 -

'# length = mil
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 2 fmax = 5
'# created = '[VERSION]2024.0|33.0.1|20230901[/VERSION]


'@ use template: Planar Filter_2.cfg

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

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
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
End With

' mesh - Tetrahedral
With Mesh
     .MeshType "Tetrahedral"
     .SetCreator "High Frequency"
End With
With MeshSettings
     .SetMeshType "Tet"
     .Set "Version", 1%

     .Set "StepsPerWaveNear", "6"
     .Set "StepsPerBoxNear", "10"
     .Set "CellsPerWavelengthPolicy", "automatic"

     .Set "CurvatureOrder", "2"
     .Set "CurvatureOrderPolicy", "automatic"

     .Set "CurvRefinementControl", "NormalTolerance"
     .Set "NormalTolerance", "60"

     .Set "SrfMeshGradation", "1.5"

     .Set "UseAnisoCurveRefinement", "1"
     .Set "UseSameSrfAndVolMeshGradation", "1"
     .Set "VolMeshGradation", "1.5"
End With

With MeshSettings
     .SetMeshType "Unstr"
     .Set "MoveMesh", "1"
     .Set "OptimizeForPlanarStructures", "0"
End With

With Mesh
     .MeshType "PBA"
     .SetCreator "High Frequency"
     .AutomeshRefineAtPecLines "True", "4"

     .UseRatioLimit "True"
     .RatioLimit "50"
     .LinesPerWavelength "20"
     .MinimumStepNumber "10"
     .Automesh "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "50"
     .Set "StepsPerWaveNear", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "4"
End With

' mesh - Multilayer (Preview)
' default

' solver - FD settings
With FDSolver
     .Reset
     .Method "Tetrahedral Mesh" ' i.e. general purpose

     .AccuracyHex "1e-6"
     .AccuracyTet "1e-5"
     .AccuracySrf "1e-3"

     .SetUseFastResonantForSweepTet "False"

     .Type "Direct"
     .MeshAdaptionHex "False"
     .MeshAdaptionTet "True"

     .InterpolationSamples "5001"
End With

With MeshAdaption3D
    .SetType "HighFrequencyTet"
    .SetAdaptionStrategy "Energy"
    .MinPasses "3"
    .MaxPasses "10"
End With

FDSolver.SetShieldAllPorts "True"

With FDSolver
     .Method "Tetrahedral Mesh (MOR)"
     .HexMORSettings "", "5001"
End With

FDSolver.Method "Tetrahedral Mesh" ' i.e. general purpose

' solver - TD settings
With MeshAdaption3D
    .SetType "Time"

    .SetAdaptionStrategy "Energy"
    .CellIncreaseFactor "0.5"
    .AddSParameterStopCriterion "True", "0.0", "10", "0.01", "1", "True"
End With

With Solver
     .Method "Hexahedral"
     .SteadyStateLimit "-40"

     .MeshAdaption "True"
     .NumberOfPulseWidths "50"

     .FrequencySamples "5001"

     .UseArfilter "True"
End With

' solver - M settings

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

'@ import odbpp file: C:\Users\PinJung\Desktop\computer_share\CST simulation\SecondWilkinson PD\Wilkinson PD-odb_2.zip

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LayoutDB
     .Reset 
     .SourceFileName "C:\Users\PinJung\Desktop\computer_share\CST simulation\SecondWilkinson PD\Wilkinson PD-odb_2.zip" 
     .LdbFileName "*Wilkinson PD-odb_2.ldb" 
     .PcbType "odbpp" 
     .KeepSynchronized "True" 
     .CreateDB 
     .LoadDB 
End With

'@ delete shapes

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Delete "Wilkinson PD-odb_2(PCB1)/Substrates:01_F.MASK" 
Solid.Delete "Wilkinson PD-odb_2(PCB1)/Substrates:03_DIELECTRIC_1" 
Solid.Delete "Wilkinson PD-odb_2(PCB1)/Substrates:05_B.MASK"

'@ delete component: Wilkinson PD-odb_2(PCB1)/Substrates

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Component.Delete "Wilkinson PD-odb_2(PCB1)/Substrates"

'@ change component: Wilkinson PD-odb_2(PCB1)/Nets/NET-(U1-PORT3):02_F.CU to: Wilkinson PD-odb_2(PCB1):02_F.CU

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.ChangeComponent "Wilkinson PD-odb_2(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", "Wilkinson PD-odb_2(PCB1)"

'@ delete component: Wilkinson PD-odb_2(PCB1)/Nets

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Component.Delete "Wilkinson PD-odb_2(PCB1)/Nets"

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb_2(PCB1):02_F.CU", "1"

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

'@ define extrude: Wilkinson PD-odb_2(PCB1):WPD

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Extrude 
     .Reset 
     .Name "WPD" 
     .Component "Wilkinson PD-odb_2(PCB1)" 
     .Material "Copper (pure)" 
     .Mode "Picks" 
     .Height "trace_t" 
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
Pick.PickMidpointFromId "Wilkinson PD-odb_2(PCB1):WPD", "125"

'@ align wcs with point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb_2(PCB1):WPD", "109"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb_2(PCB1):WPD", "59"

'@ define material: Rogers RO4350B (lossy)

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Material
     .Reset
     .Name "Rogers RO4350B (lossy)"
     .Folder ""
     .FrqType "all"
     .Type "Normal"
     .SetMaterialUnit "GHz", "mm"
     .Epsilon "3.66"
     .Mu "1.0"
     .Kappa "0.0"
     .TanD "0.0037"
     .TanDFreq "10.0"
     .TanDGiven "True"
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
     .ThermalConductivity "0.69"
     .SetActiveMaterial "all"
     .Colour "0.94", "0.82", "0.76"
     .Wireframe "False"
     .Transparency "0"
     .Create
End With

'@ define brick: Wilkinson PD-odb_2(PCB1):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "Wilkinson PD-odb_2(PCB1)" 
     .Material "Rogers RO4350B (lossy)" 
     .Xrange "0", "length" 
     .Yrange "-width/2", "width/2" 
     .Zrange "-0", "sub_t" 
     .Create
End With

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb_2(PCB1):solid1", "1"

'@ define extrude: Wilkinson PD-odb_2(PCB1):pec

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Extrude 
     .Reset 
     .Name "pec" 
     .Component "Wilkinson PD-odb_2(PCB1)" 
     .Material "PEC" 
     .Mode "Picks" 
     .Height "pec_t" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "False" 
     .DeleteBaseFaceSolid "False" 
     .KeepMaterials "False" 
     .ClearPickedFace "True" 
     .Create 
End With

'@ rename block: Wilkinson PD-odb_2(PCB1):solid1 to: Wilkinson PD-odb_2(PCB1):substrate

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Rename "Wilkinson PD-odb_2(PCB1):solid1", "substrate"

'@ delete shape: Wilkinson PD-odb_2(PCB1):02_F.CU

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Delete "Wilkinson PD-odb_2(PCB1):02_F.CU"

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb_2(PCB1):WPD", "30"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb_2(PCB1):WPD", "3"

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
     .SetP1 "False", "501", "-9.4499998973356", "-1.37" 
     .SetP2 "False", "501", "9.4499998973361", "-1.37" 
     .SetInvert "False" 
     .Wire "" 
     .Position "end1" 
     .Create
End With

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb_2(PCB1):WPD", "67"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb_2(PCB1):WPD", "187"

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
     .SetP1 "True", "810.80000027848", "-9.4499998973356", "-1.37" 
     .SetP2 "True", "810.80000027848", "9.4499998973361", "-1.37" 
     .SetInvert "False" 
     .Wire "" 
     .Position "end1" 
     .Create
End With

'@ pick point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickPointFromCoordinates "0", "-11.161511193944", "1.3052065362462"

'@ delete shape: Wilkinson PD-odb_2(PCB1):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Delete "Wilkinson PD-odb_2(PCB1):solid1"

'@ define brick: Wilkinson PD-odb_2(PCB1):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "Wilkinson PD-odb_2(PCB1)" 
     .Material "PEC" 
     .Xrange "1130", "1250" 
     .Yrange "-520", "600" 
     .Zrange "-500", "490" 
     .Create
End With

'@ boolean insert shapes: Wilkinson PD-odb_2(PCB1):WPD, Wilkinson PD-odb_2(PCB1):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Solid
     .Version 10
     .Insert "Wilkinson PD-odb_2(PCB1):WPD", "Wilkinson PD-odb_2(PCB1):solid1" 
     .Version 1
End With

'@ boolean insert shapes: Wilkinson PD-odb_2(PCB1):pec, Wilkinson PD-odb_2(PCB1):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Solid
     .Version 10
     .Insert "Wilkinson PD-odb_2(PCB1):pec", "Wilkinson PD-odb_2(PCB1):solid1" 
     .Version 1
End With

'@ boolean subtract shapes: Wilkinson PD-odb_2(PCB1):substrate, Wilkinson PD-odb_2(PCB1):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Subtract "Wilkinson PD-odb_2(PCB1):substrate", "Wilkinson PD-odb_2(PCB1):solid1"

'@ define brick: Wilkinson PD-odb_2(PCB1):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "Wilkinson PD-odb_2(PCB1)" 
     .Material "PEC" 
     .Xrange "-60", "10" 
     .Yrange "-540", "520" 
     .Zrange "-500", "440" 
     .Create
End With

'@ boolean insert shapes: Wilkinson PD-odb_2(PCB1):WPD, Wilkinson PD-odb_2(PCB1):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Solid
     .Version 10
     .Insert "Wilkinson PD-odb_2(PCB1):WPD", "Wilkinson PD-odb_2(PCB1):solid1" 
     .Version 1
End With

'@ boolean insert shapes: Wilkinson PD-odb_2(PCB1):pec, Wilkinson PD-odb_2(PCB1):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Solid
     .Version 10
     .Insert "Wilkinson PD-odb_2(PCB1):pec", "Wilkinson PD-odb_2(PCB1):solid1" 
     .Version 1
End With

'@ boolean subtract shapes: Wilkinson PD-odb_2(PCB1):substrate, Wilkinson PD-odb_2(PCB1):solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Subtract "Wilkinson PD-odb_2(PCB1):substrate", "Wilkinson PD-odb_2(PCB1):solid1"

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb_2(PCB1):WPD", "82"

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
     .Xrange "6762.0500000027", "6762.0500000027"
     .Yrange "-3072.1310002407", "-3030.2309994028"
     .Zrange "0", "1.37"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "sub_t*6", "sub_t*6"
     .ZrangeAdd "sub_t*6", "sub_t"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb_2(PCB1):WPD", "10"

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
     .Xrange "6762.0500000027", "6762.0500000027"
     .Yrange "-3553.7690004533", "-3511.8689996154"
     .Zrange "0", "1.37"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "sub_t*6", "sub_t*6"
     .ZrangeAdd "sub_t*6", "sub_t"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb_2(PCB1):WPD", "6"

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
     .Xrange "5642.0500000027", "5642.0500000027"
     .Yrange "-3312.950000347", "-3271.0499995091"
     .Zrange "0", "1.37"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "sub_t*6", "sub_t*6"
     .ZrangeAdd "sub_t*6", "sub_t"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ rename port: 1 to: 4

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Port.Rename "1", "4"

'@ rename port: 3 to: 1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Port.Rename "3", "1"

'@ rename port: 4 to: 3

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Port.Rename "4", "3"

'@ define boundaries

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "electric"
     .Ymax "electric"
     .Zmin "expanded open"
     .Zmax "electric"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
     .OpenAddSpaceFactor "0.5"
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
     .SetShieldAllPorts "True" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Direct" 
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
     .SetNumberOfResultDataSamples "5001" 
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

'@ modify lumped element: Folder1:R1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LumpedElement
     .Reset 
     .SetName "R1" 
     .Folder "Folder1" 
     .Modify
End With

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb_2(PCB1):WPD", "42"

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
     .Xrange "5632.0500000027", "5632.0500000027"
     .Yrange "-3312.950000347", "-3271.0499995091"
     .Zrange "0", "1.37"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "sub_t*6", "sub_t*6"
     .ZrangeAdd "sub_t*6", "sub_t"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb_2(PCB1):WPD", "55"

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
     .Xrange "6772.9189999973", "6772.9189999973"
     .Yrange "-3072.1310002407", "-3030.2309994028"
     .Zrange "0", "1.37"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "sub_t*6", "sub_t*6"
     .ZrangeAdd "sub_t*6", "sub_t"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb_2(PCB1):WPD", "29"

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
     .Xrange "6772.9189999973", "6772.9189999973"
     .Yrange "-3553.7690004533", "-3511.8689996154"
     .Zrange "0", "1.37"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "sub_t*6", "sub_t*6"
     .ZrangeAdd "sub_t*6", "sub_t"
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
     .Zmin "expanded open"
     .Zmax "electric"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
     .OpenAddSpaceFactor "0.5"
End With

'@ set 3d mesh adaptation properties

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "10" 
    .MaxPasses "20" 
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
     .SetMethod "Hexahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "True" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "True" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Direct" 
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
     .SetNumberOfResultDataSamples "5001" 
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

'@ set 3d mesh adaptation properties

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "10" 
    .MaxPasses "20" 
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
     .SetShieldAllPorts "True" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Direct" 
     .MeshAdaptionHex "True" 
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
     .SetNumberOfResultDataSamples "5001" 
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

'@ delete lumped element: Folder1:R2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
LumpedElement.Delete "Folder1:R2"

'@ set 3d mesh adaptation properties

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "5" 
    .MaxPasses "12" 
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

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb_2(PCB1):WPD", "30"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb_2(PCB1):WPD", "3"

'@ define lumped element: R2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LumpedElement
     .Reset 
     .SetName "R2" 
     .Folder "" 
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
     .SetP1 "True", "494.26500015347", "-9.4499998973356", "-1.37" 
     .SetP2 "True", "494.26500015347", "9.4499998973361", "-1.37" 
     .SetInvert "False" 
     .Wire "" 
     .Position "end1" 
     .Create
End With

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb_2(PCB1):WPD", "67"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb_2(PCB1):WPD", "187"

'@ define lumped element: R1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LumpedElement
     .Reset 
     .SetName "R1" 
     .Folder "" 
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
     .SetP1 "True", "810.80000027848", "-9.4499998973356", "-1.37" 
     .SetP2 "True", "810.80000027848", "9.4499998973361", "-1.37" 
     .SetInvert "False" 
     .Wire "" 
     .Position "end1" 
     .Create
End With

