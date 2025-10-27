'# MWS Version: Version 2024.0 - Sep 01 2023 - ACIS 33.0.1 -

'# length = mil
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 9 fmax = 12
'# created = '[VERSION]2024.0|33.0.1|20230901[/VERSION]


'@ use template: Planar Filter_8.cfg

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
Solver.FrequencyRange "9", "12"

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

'@ import gerber file: C:\Users\PinJung\Desktop\computer_share\CST simulation\Structure from Kicad\WPD_Cu_10500MHz_test3.gbr

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LayoutDB
     .Reset 
     .SourceFileName "C:\Users\PinJung\Desktop\computer_share\CST simulation\Structure from Kicad\WPD_Cu_10500MHz_test3.gbr" 
     .LdbFileName "*WPD_Cu_10500MHz_test3.ldb" 
     .PcbType "gerber" 
     .KeepSynchronized "True" 
     .CreateDB 
     .LoadDB 
End With

'@ change component: WPD_Cu_10500MHz_test3(PCB1)/Nets/NONE:WPD_CU_10500MHZ_TEST3.GBR to: WPD_Cu_10500MHz_test3(PCB1):WPD_CU_10500MHZ_TEST3.GBR

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Solid.ChangeComponent "WPD_Cu_10500MHz_test3(PCB1)/Nets/NONE:WPD_CU_10500MHZ_TEST3.GBR", "WPD_Cu_10500MHz_test3(PCB1)"

'@ delete component: WPD_Cu_10500MHz_test3(PCB1)/Nets

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Component.Delete "WPD_Cu_10500MHz_test3(PCB1)/Nets"

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "WPD_Cu_10500MHz_test3(PCB1):WPD_CU_10500MHZ_TEST3.GBR", "1"

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

'@ define brick: WPD_Cu_10500MHz_test3(PCB1):Substrate

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Brick
     .Reset 
     .Name "Substrate" 
     .Component "WPD_Cu_10500MHz_test3(PCB1)" 
     .Material "Rogers RO4350B (lossy)" 
     .Xrange "7000", "8600" 
     .Yrange "-3700", "-2350" 
     .Zrange "0", "-20" 
     .Create
End With

'@ unpick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.UnpickFaceFromId "WPD_Cu_10500MHz_test3(PCB1):WPD_CU_10500MHZ_TEST3.GBR", "1"

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "WPD_Cu_10500MHz_test3(PCB1):WPD_CU_10500MHZ_TEST3.GBR", "1"

'@ define material: Copper

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Material
     .Reset
     .Name "Copper"
     .Folder ""
     .Rho "8930"
     .ThermalType "Normal"
     .ThermalConductivity "401"
     .SpecificHeat "390", "J/K/kg"
     .DynamicViscosity "0"
     .UseEmissivity "True"
     .Emissivity "0"
     .MetabolicRate "0"
     .VoxelConvection "0"
     .BloodFlow "0"
     .Absorptance "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "120"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "17"
     .IntrinsicCarrierDensity "0"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Mu "1"
     .Sigma "5.8e+07"
     .LossyMetalSIRoughness "0.0"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .FrqType "static"
     .Type "Normal"
     .MaterialUnit "Frequency", "Hz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "1"
     .Mu "1"
     .Sigma "5.8e+07"
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
     .SigmaM "0"
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
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .FrqType "hf"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Mu "1"
     .Sigma "5.8e+07"
     .LossyMetalSIRoughness "0.0"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.703", "0.703", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define extrude: WPD_Cu_10500MHz_test3(PCB1):WPD

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Extrude 
     .Reset 
     .Name "WPD" 
     .Component "WPD_Cu_10500MHz_test3(PCB1)" 
     .Material "Copper" 
     .Mode "Picks" 
     .Height "1.38" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "False" 
     .DeleteBaseFaceSolid "False" 
     .KeepMaterials "False" 
     .ClearPickedFace "True" 
     .Create 
End With

'@ activate local coordinates

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.ActivateWCS "local"

'@ activate global coordinates

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.ActivateWCS "local"

'@ activate global coordinates

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.ActivateWCS "local"

'@ activate global coordinates

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.ActivateWCS "local"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "44"

'@ activate global coordinates

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.ActivateWCS "local"

'@ align wcs with point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "170"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "194"

'@ define lumped element: Folder1:R1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LumpedElement
     .Reset 
     .SetName "R1" 
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
     .SetP1 "True", "545.99999986169", "8.249999788592", "0" 
     .SetP2 "True", "545.99999986169", "-10.649998690349", "0" 
     .SetInvert "False" 
     .Wire "" 
     .Position "end1" 
     .Create
End With

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "134"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "218"

'@ define lumped element: Folder1:R2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LumpedElement
     .Reset 
     .SetName "R2" 
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
     .SetP1 "True", "653.12230377388", "8.275000494009", "0" 
     .SetP2 "True", "653.12230377388", "-10.674999395766", "0" 
     .SetInvert "False" 
     .Wire "" 
     .Position "end1" 
     .Create
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "WPD_Cu_10500MHz_test3(PCB1):Substrate", "2"

'@ define extrude: WPD_Cu_10500MHz_test3(PCB1):PEC

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Extrude 
     .Reset 
     .Name "PEC" 
     .Component "WPD_Cu_10500MHz_test3(PCB1)" 
     .Material "PEC" 
     .Mode "Picks" 
     .Height "1" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "False" 
     .DeleteBaseFaceSolid "False" 
     .KeepMaterials "False" 
     .ClearPickedFace "True" 
     .Create 
End With

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "WPD_Cu_10500MHz_test3(PCB1):PEC", "8"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "WPD_Cu_10500MHz_test3(PCB1):Substrate", "2"

'@ define distance dimension

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "0"
    .SetOrientation "Smart Mode"
    .SetDistance "31.978502"
    .SetViewVector "-0.962270", "-0.263962", "-0.066033"
    .SetConnectedElement1 "WPD_Cu_10500MHz_test3(PCB1):PEC"
    .SetConnectedElement2 "WPD_Cu_10500MHz_test3(PCB1):Substrate"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "WPD_Cu_10500MHz_test3(PCB1):Substrate", "2"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "WPD_Cu_10500MHz_test3(PCB1):PEC", "1"

'@ define distance dimension

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "1"
    .SetOrientation "Smart Mode"
    .SetDistance "-6.386314"
    .SetViewVector "-0.922431", "-0.384272", "-0.038145"
    .SetConnectedElement1 "WPD_Cu_10500MHz_test3(PCB1):Substrate"
    .SetConnectedElement2 "WPD_Cu_10500MHz_test3(PCB1):PEC"
    .Create
End With

Pick.ClearAllPicks

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "15"

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
     .Xrange "7065.0000000035", "7065.0000000035"
     .Yrange "-3046.0000002791", "-3004.0000008191"
     .Zrange "0", "1.38"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "5.12*20", "5.12*20"
     .ZrangeAdd "20", "5.12*20"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "34"

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
     .Xrange "8570.3340944847", "8570.3340944847"
     .Yrange "-2626.1999995251", "-2584.2000000652"
     .Zrange "0", "1.38"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "5.12*20", "5.12*20"
     .ZrangeAdd "20", "5.12*20"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick face

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickFaceFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "84"

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
     .Xrange "8570.3340944847", "8570.3340944847"
     .Yrange "-3468.1999999348", "-3426.2000004749"
     .Zrange "0", "1.38"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "5.12*20", "5.12*20"
     .ZrangeAdd "20", "5.12*20"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
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
     .AutoNormImpedance "False" 
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

'@ define boundaries

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "electric"
     .Ymax "electric"
     .Zmin "electric"
     .Zmax "expanded open"
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

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "89"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "91"

'@ define distance dimension

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "2"
    .SetOrientation "Smart Mode"
    .SetDistance "4.363678"
    .SetViewVector "0.104303", "0.908366", "-0.404960"
    .SetConnectedElement1 "WPD_Cu_10500MHz_test3(PCB1):WPD"
    .SetConnectedElement2 "WPD_Cu_10500MHz_test3(PCB1):WPD"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "115"

'@ pick end point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickEndpointFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "113"

'@ define distance dimension

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "3"
    .SetOrientation "Smart Mode"
    .SetDistance "3.709135"
    .SetViewVector "-0.071829", "0.735615", "-0.673581"
    .SetConnectedElement1 "WPD_Cu_10500MHz_test3(PCB1):WPD"
    .SetConnectedElement2 "WPD_Cu_10500MHz_test3(PCB1):WPD"
    .Create
End With

Pick.ClearAllPicks

'@ delete lumped element: Folder1:R2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
LumpedElement.Delete "Folder1:R2"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "134"

'@ activate global coordinates

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.ActivateWCS "global"

'@ align wcs with point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ set wcs properties

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With WCS
     .SetNormal "0", "0", "1"
     .SetOrigin "7718.1223037774", "-3016.7250000551", "1.38"
     .SetUVector "1", "0", "0"
End With

'@ clear picks

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.ClearAllPicks

'@ pick point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickPointFromCoordinates "-10", "0", "0"

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "218"

'@ align wcs with point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ pick point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickPointFromCoordinates "-10", "0", "0"

'@ define lumped element: Folder1:r2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With LumpedElement
     .Reset 
     .SetName "r2" 
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
     .SetP1 "True", "-9.99999999998", "18.949999889788", "2.2204460492503e-16" 
     .SetP2 "True", "-10", "0", "0" 
     .SetInvert "False" 
     .Wire "" 
     .Position "end1" 
     .Create
End With

'@ pick mid point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
Pick.PickMidpointFromId "WPD_Cu_10500MHz_test3(PCB1):WPD", "44"

'@ align wcs with point

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ delete dimension 0

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Dimension
    .RemoveDimension "0"
End With

'@ delete dimension 2

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Dimension
    .RemoveDimension "2"
End With

'@ delete dimension 3

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Dimension
    .RemoveDimension "3"
End With

'@ delete dimension 1

'[VERSION]2024.0|33.0.1|20230901[/VERSION]
With Dimension
    .RemoveDimension "1"
End With

