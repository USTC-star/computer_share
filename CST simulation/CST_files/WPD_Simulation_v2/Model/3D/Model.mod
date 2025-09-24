'# MWS Version: Version 2024.0 - Sep 01 2023 - ACIS 33.0.1 -

'# length = mil
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 2 fmax = 5
'# created = '[VERSION]2024.0|33.0.1|20230901[/VERSION]


'@ use template: Planar Filter_1.cfg

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

'@ import odbpp file: C:\Users\PinJung\Desktop\computer_share\CST simulation\SecondWilkinson PD\Wilkinson PD-odb.zip

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LayoutDB
     .Reset 
     .SourceFileName "C:\Users\PinJung\Desktop\computer_share\CST simulation\SecondWilkinson PD\Wilkinson PD-odb.zip" 
     .LdbFileName "*Wilkinson PD-odb.ldb" 
     .PcbType "odbpp" 
     .KeepSynchronized "True" 
     .CreateDB 
     .LoadDB 
End With

'@ delete shapes

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Delete "Wilkinson PD-odb(PCB1)/Substrates:01_F.MASK" 
Solid.Delete "Wilkinson PD-odb(PCB1)/Substrates:03_DIELECTRIC_1" 
Solid.Delete "Wilkinson PD-odb(PCB1)/Substrates:05_B.MASK"

'@ change component: Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU to: Wilkinson PD-odb(PCB1):02_F.CU

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.ChangeComponent "Wilkinson PD-odb(PCB1)/Nets/NET-(U1-PORT3):02_F.CU", "Wilkinson PD-odb(PCB1)"

'@ delete component: Wilkinson PD-odb(PCB1)/Nets

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Component.Delete "Wilkinson PD-odb(PCB1)/Nets"

'@ change component: Wilkinson PD-odb(PCB1):02_F.CU to: Wilkinson PD-odb(PCB1)/Substrates:02_F.CU

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.ChangeComponent "Wilkinson PD-odb(PCB1):02_F.CU", "Wilkinson PD-odb(PCB1)/Substrates"

'@ change component: Wilkinson PD-odb(PCB1)/Substrates:02_F.CU to: Wilkinson PD-odb(PCB1):02_F.CU

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.ChangeComponent "Wilkinson PD-odb(PCB1)/Substrates:02_F.CU", "Wilkinson PD-odb(PCB1)"

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1):02_F.CU", "1"

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

'@ define extrude: Wilkinson PD-odb(PCB1):wpd

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Extrude 
     .Reset 
     .Name "wpd" 
     .Component "Wilkinson PD-odb(PCB1)" 
     .Material "Copper (pure)" 
     .Mode "Picks" 
     .Height "1.37" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "False" 
     .DeleteBaseFaceSolid "False" 
     .KeepMaterials "False" 
     .ClearPickedFace "True" 
     .Create 
End With

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb(PCB1):wpd", "29"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb(PCB1):wpd", "2"

'@ define curve line: curve1:line1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "6126.5" 
     .Y1 "-3282.5" 
     .X2 "6126" 
     .Y2 "-3302" 
     .Create
End With

'@ delete curve item: curve1:line1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Curve.DeleteCurveItem "curve1", "line1"

'@ define curve rectangle: curve1:rectangle1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Rectangle
     .Reset 
     .Name "rectangle1" 
     .Curve "curve1" 
     .Xrange "6146", "6174" 
     .Yrange "-3301", "-3283" 
     .Create
End With

'@ pick center point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickCenterpointFromId "Wilkinson PD-odb(PCB1):wpd", "69"

'@ delete curve: curve1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Curve.DeleteCurve "curve1"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1):wpd", "125"

'@ align wcs with point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ align wcs with edge and face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1):wpd", "69" 
Pick.PickEdgeFromId "Wilkinson PD-odb(PCB1):wpd", "134", "89" 
WCS.AlignWCSWithSelected "EdgeAndFace"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1):wpd", "125"

'@ align wcs with point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ align wcs with edge and face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1):wpd", "69" 
Pick.PickEdgeFromId "Wilkinson PD-odb(PCB1):wpd", "122", "81" 
WCS.AlignWCSWithSelected "EdgeAndFace"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb(PCB1):wpd", "85"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb(PCB1):wpd", "109"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "Wilkinson PD-odb(PCB1):wpd", "125"

'@ align wcs with three points

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.AlignWCSWithSelected "3Points"

'@ align wcs with edge and face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1):wpd", "69" 
Pick.PickEdgeFromId "Wilkinson PD-odb(PCB1):wpd", "125", "83" 
WCS.AlignWCSWithSelected "EdgeAndFace"

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb(PCB1):wpd", "109"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "Wilkinson PD-odb(PCB1):wpd", "59"

'@ delete shape: Wilkinson PD-odb(PCB1):02_F.CU

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Delete "Wilkinson PD-odb(PCB1):02_F.CU"

'@ delete material: Wilkinson PD-odb(PCB1)

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Material.DeleteFolder "Wilkinson PD-odb(PCB1)"

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

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1):wpd", "69"

'@ new component: Wilkinson PD

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Component.New "Wilkinson PD"

'@ define brick: Wilkinson PD:solid1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "Wilkinson PD" 
     .Material "Rogers RO4350B (lossy)" 
     .Xrange "-width/2", "width/2" 
     .Yrange "0", "length" 
     .Zrange "0", "sub_t" 
     .Create
End With

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ rename block: Wilkinson PD:solid1 to: Wilkinson PD:substrate

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.Rename "Wilkinson PD:solid1", "substrate"

'@ change component: Wilkinson PD:substrate to: Wilkinson PD-odb(PCB1):substrate

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.ChangeComponent "Wilkinson PD:substrate", "Wilkinson PD-odb(PCB1)"

'@ delete component: Wilkinson PD-odb(PCB1)/Substrates

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Component.Delete "Wilkinson PD-odb(PCB1)/Substrates"

'@ delete component: Wilkinson PD

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Component.Delete "Wilkinson PD"

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1):substrate", "1"

'@ new component: component1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Component.New "component1"

'@ define extrude: component1:pec

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Extrude 
     .Reset 
     .Name "pec" 
     .Component "component1" 
     .Material "PEC" 
     .Mode "Picks" 
     .Height "PEC_t" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "False" 
     .DeleteBaseFaceSolid "False" 
     .KeepMaterials "False" 
     .ClearPickedFace "True" 
     .Create 
End With

'@ change component: component1:pec to: Wilkinson PD-odb(PCB1):pec

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.ChangeComponent "component1:pec", "Wilkinson PD-odb(PCB1)"

'@ delete component: component1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Component.Delete "component1"

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1):wpd", "42"

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
     .Xrange "5632.0500000024", "5632.0500000024"
     .Yrange "-3312.950000586", "-3271.0499995808"
     .Zrange "0", "1.37"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "sub_t*5.8", "sub_t*5.8"
     .ZrangeAdd "sub_t", "sub_t*5.8"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ modify port: 1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Port 
     .Reset 
     .LoadContentForModify "1" 
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
     .Xrange "5632.05", "5632.05"
     .Yrange "-3312.950001", "-3271.05"
     .Zrange "0", "1.37"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "sub_t*5.8", "sub_t*5.8"
     .ZrangeAdd "sub_t*5.8", "sub_t"
     .SingleEnded "False"
     .Shield "none"
     .WaveguideMonitor "False"
     .Modify 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1):wpd", "55"

'@ modify port: 1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Port 
     .Reset 
     .LoadContentForModify "1" 
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
     .Xrange "5632.05", "5632.05"
     .Yrange "-3312.950001", "-3271.05"
     .Zrange "0", "1.37"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "sub_t*6", "sub_t*6"
     .ZrangeAdd "sub_t*6", "sub_t"
     .SingleEnded "False"
     .Shield "none"
     .WaveguideMonitor "False"
     .Modify 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1):wpd", "55"

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
     .Xrange "6674.4929999976", "6674.4929999976"
     .Yrange "-3190.2410000667", "-3148.3410004231"
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
Pick.PickFaceFromId "Wilkinson PD-odb(PCB1):wpd", "29"

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
     .Xrange "6674.4929999976", "6674.4929999976"
     .Yrange "-3435.6589997436", "-3393.7590001001"
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

'@ modify port: 3

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Port 
     .Reset 
     .LoadContentForModify "3" 
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
     .Xrange "6674.493", "6674.493"
     .Yrange "-3435.659", "-3393.759"
     .Zrange "0", "1.37"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "sub_t*5", "sub_t*5"
     .ZrangeAdd "sub_t*5", "sub_t"
     .SingleEnded "False"
     .Shield "none"
     .WaveguideMonitor "False"
     .Modify 
End With

'@ delete port: port3

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Port.Delete "3"

