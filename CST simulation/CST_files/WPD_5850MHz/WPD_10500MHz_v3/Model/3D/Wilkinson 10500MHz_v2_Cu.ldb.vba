#-> section

With SAT
    .Reset
    .FileName "*Wilkinson 10500MHz_v2_Cu.ldb.sab"
    .Version "9.0"
    .ScaleToUnit True
    .ImportToActiveCoordinateSystem True
    .Curves True
    .Wires True
    .MergeFaces False
    .SubProjectName3D "PCB_UID_110173_repl_token"
    .SubProjectScaleFactor 0.001
    .Read
    End With


#-> section

Curve.NewCurve "PCB_UID_110173_UTR_PICK"

#-> section

Mesh.StartSubProjectAdd

#-> section

With Material
   .Reset
   .Name "Copper"
   .Folder "PCB_UID_110173_UTR"
   .Colour 0.703, 0.703, 0
   .Wireframe False
   .Transparency 0
    .FrqType "static"
    .Type "Normal"
    .SetMaterialUnit "Hz", "mm"
    .Epsilon "1"
    .Mu "1"
    .Kappa "5.8e+07"
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
    .FrqType "all"
    .Type "Lossy metal"
    .SetMaterialUnit "GHz", "mm"
    .Mu "1"
    .Kappa "5.8e+07"
    .Rho "8930"
    .ThermalType "Normal"
    .ThermalConductivity "401"
    .SpecificHeat "390"
    .MetabolicRate "0"
    .BloodFlow "0"
    .VoxelConvection "0"
    .MechanicsType "Isotropic"
    .YoungsModulus "120"
    .PoissonsRatio "0.33"
    .ThermalExpansionRate "17"
    .Reflection "False"
    .Allowoutline "True"
    .Transparentoutline "False"
    .Create
End With


#-> section

With Material
   .Reset
   .Name "VIAS_MATERIAL"
   .Folder "PCB_UID_110173_UTR"
   .Colour 1, 0, 0
   .Wireframe False
   .Transparency 0
    .FrqType "static"
    .Type "Normal"
    .SetMaterialUnit "Hz", "mm"
    .Epsilon "1"
    .Mu "1"
    .Kappa "5.8e+07"
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
    .FrqType "all"
    .Type "Lossy metal"
    .SetMaterialUnit "GHz", "mm"
    .Mu "1"
    .Kappa "5.8e+07"
    .Rho "8930"
    .ThermalType "Normal"
    .ThermalConductivity "401"
    .SpecificHeat "390"
    .MetabolicRate "0"
    .BloodFlow "0"
    .VoxelConvection "0"
    .MechanicsType "Isotropic"
    .YoungsModulus "120"
    .PoissonsRatio "0.33"
    .ThermalExpansionRate "17"
    .Reflection "False"
    .Allowoutline "True"
    .Transparentoutline "False"
    .Create
End With


#-> section

With Material
   .Reset
   .Name "PEC Sheets"
   .Folder "PCB_UID_110173_UTR"
   .Type "Pec"
   .Rho "0.0"
   .ThermalType "Normal"
   .ThermalConductivity "0"
   .SpecificHeat "0"
   .DynamicViscosity "0"
   .Emissivity "0"
   .MetabolicRate "0.0"
   .VoxelConvection "0.0"
   .BloodFlow "0"
   .MechanicsType "Unused"
   .FrqType "static"
   .Type "Pec"
   .MaterialUnit "Time", "s"
   .Epsilon "1"
   .Mu "1"
   .ReferenceCoordSystem "Global"
   .CoordSystemType "Cartesian"
   .NLAnisotropy "False"
   .NLAStackingFactor "1"
   .NLADirectionX "1"
   .NLADirectionY "0"
   .NLADirectionZ "0"
   .FrqType "all"
   .Type "Pec"
   .MaterialUnit "Time", "s"
   .Epsilon "1"
   .Mu "1"
   .ReferenceCoordSystem "Global"
   .CoordSystemType "Cartesian"
   .NLAnisotropy "False"
   .NLAStackingFactor "1"
   .NLADirectionX "1"
   .NLADirectionY "0"
   .NLADirectionZ "0"
   .Colour "0.588235", "0.588235", "0.588235"
   .Wireframe False
   .Reflection "False"
   .Allowoutline "True"
   .Transparentoutline "True"
   .Transparency 30
   .Create
End With


#-> section

Solid.SetUseIndividualColor "PCB_UID_110173_UTR/Nets/NONE:WILKINSON 10500MHZ_V2_CU.GBR", 1
Solid.ChangeIndividualColor "PCB_UID_110173_UTR/Nets/NONE:WILKINSON 10500MHZ_V2_CU.GBR", 179, 179, 0


#-> section

' Creating groups =====
Group.NewFolder "PCB_UID_110173_UTR"
Group.NewFolder "PCB_UID_110173_UTR/Layers"
Group.NewFolder "PCB_UID_110173_UTR/Vias"
Group.NewFolder "PCB_UID_110173_UTR/Nets"
Group.NewFolder "PCB_UID_110173_UTR/Ports"
Group.NewFolder "PCB_UID_110173_UTR/Auxiliary Geometry"
Group.NewFolder "PCB_UID_110173_UTR/Auxiliary Geometry/PEC"
Group.NewFolder "PCB_UID_110173_UTR/Auxiliary Geometry/Components"
Group.NewFolder "PCB_UID_110173_UTR/Auxiliary Geometry/HeatSources"
Group.NewFolder "PCB_UID_110173_UTR/Auxiliary Geometry/RLC Node Support"
Group.NewFolder "PCB_UID_110173_UTR/Simplified Geometry"
Group.Add "PCB_UID_110173_UTR/Layers:WILKINSON 10500MHZ_V2_CU.GBR", "normal"
Group.AddItem "solid$PCB_UID_110173_UTR/Nets/NONE:WILKINSON 10500MHZ_V2_CU.GBR", "PCB_UID_110173_UTR/Layers:WILKINSON 10500MHZ_V2_CU.GBR"



#-> section

MeshSettings.AdjustItemMeshSettingsStart

#-> section

Group.Add "meshgroup1", "mesh"

#-> section

With MeshSettings
With .ItemMeshSettings ("group$meshgroup1")
.SetMeshType "Hex"

          .Set "ConsiderGlobalEdgeRefinement", 0
          .Set "ConsiderGlobalFaceRefinement", 0
          .Set "ConsiderGlobalMaterialRefinement", 0
          .Set "ConsiderGlobalRefinement", 0
          .Set "ConsiderGlobalSnapping", 0
          .Set "EdgeRefinementBufferLines", 3
          .Set "EdgeRefinementRatio", "1"
          .Set "EdgeRefinementStep", "0"
          .Set "EdgeRefinementType", "NONE"
          .Set "EllipseRefinementNSteps", 2
          .Set "EllipseRefinementRatio", 2
          .Set "EllipseRefinementStep", 0
          .Set "EllipseRefinementType", "NONE"
          .Set "FaceRefinementBufferLines", 3
          .Set "FaceRefinementNSteps", 2
          .Set "FaceRefinementRatio", 2
          .Set "FaceRefinementStep", 0
          .Set "FaceRefinementType", "NONE"
          .Set "SnappingIntervals", 0, 0, 0
          .Set "SnappingPriority", 0
          .Set "SnapToAxialEdges", 0
          .Set "SnapToCylinderCenters", 0
          .Set "SnapToCylinders", 0
          .Set "SnapToEllipseCenters", 0
          .Set "SnapToEllipses", 0
          .Set "SnapToObjectBoundaries", 0
          .Set "SnapToPlanes", "0"
          .Set "SnapToSpheres", 0
          .Set "SnapToTori", 0
          .Set "SnapXYZ", "0", "0", "0"
          .Set "UseMaterialRefinement", 0
          .Set "UseSnappingPriority", 0
          .Set "VolumeRefinementExtentNumSteps", 0, 0, 0
          .Set "VolumeRefinementExtentStep", 0, 0, 0
          .Set "VolumeRefinementExtentType", "NONE"
          .Set "VolumeRefinementExtentValueUseSameXYZ", 1
          .Set "VolumeRefinementNumSteps", "0", "0", "0"
          .Set "VolumeRefinementRatio", "0", "0", "0"
          .Set "VolumeRefinementScopeType", "ALL"
          .Set "VolumeRefinementStep", "0.000000", "0.000000", "0.000000"
          .Set "VolumeRefinementType", "NONE"
          .Set "VolumeRefinementValueUseSameXYZ", 0
    
.SetMeshType "HexTLM"

          .Set "ConsiderGlobalEdgeRefinement", 0
          .Set "ConsiderGlobalFaceRefinement", 0
          .Set "ConsiderGlobalMaterialRefinement", 0
          .Set "ConsiderGlobalRefinement", 0
          .Set "ConsiderGlobalSnapping", 0
          .Set "EdgeRefinementBufferLines", 3
          .Set "EdgeRefinementRatio", "1"
          .Set "EdgeRefinementStep", "0"
          .Set "EdgeRefinementType", "NONE"
          .Set "EllipseRefinementNSteps", 2
          .Set "EllipseRefinementRatio", 2
          .Set "EllipseRefinementStep", 0
          .Set "EllipseRefinementType", "NONE"
          .Set "FaceRefinementBufferLines", 3
          .Set "FaceRefinementNSteps", 2
          .Set "FaceRefinementRatio", 2
          .Set "FaceRefinementStep", 0
          .Set "FaceRefinementType", "NONE"
          .Set "SnappingIntervals", 0, 0, 0
          .Set "SnappingPriority", 0
          .Set "SnapToAxialEdges", 0
          .Set "SnapToCylinderCenters", 0
          .Set "SnapToCylinders", 0
          .Set "SnapToEllipseCenters", 0
          .Set "SnapToEllipses", 0
          .Set "SnapToObjectBoundaries", 0
          .Set "SnapToPlanes", "0"
          .Set "SnapToSpheres", 0
          .Set "SnapToTori", 0
          .Set "SnapXYZ", "0", "0", "0"
          .Set "UseMaterialRefinement", 0
          .Set "UseSnappingPriority", 0
          .Set "VolumeRefinementExtentNumSteps", 0, 0, 0
          .Set "VolumeRefinementExtentStep", 0, 0, 0
          .Set "VolumeRefinementExtentType", "NONE"
          .Set "VolumeRefinementExtentValueUseSameXYZ", 1
          .Set "VolumeRefinementNumSteps", "0", "0", "0"
          .Set "VolumeRefinementRatio", "0", "0", "0"
          .Set "VolumeRefinementScopeType", "ALL"
          .Set "VolumeRefinementStep", "0.000000", "0.000000", "0.000000"
          .Set "VolumeRefinementType", "NONE"
          .Set "VolumeRefinementValueUseSameXYZ", 0
    
End With
End With


#-> section

Group.AddItem "solid$PCB_UID_110173_UTR/Nets/NONE:WILKINSON 10500MHZ_V2_CU.GBR", "meshgroup1"


#-> section

MeshSettings.AdjustItemMeshSettingsEnd

#-> section

Mesh.EndSubProjectAdd

#-> section

Curve.DeleteCurve "PCB_UID_110173_UTR_PICK"

#-> section

With MeshSettings
     .SetMeshType "All"
     .Set "PrioritizationScheme", "ElectricConductivity"
End With


#-> section

Component.Rename "PCB_UID_110173_UTR", "PCB_UID_110173_repl_token"

#-> section

Group.RenameFolder "PCB_UID_110173_UTR", "PCB_UID_110173_repl_token"

#-> section

Material.RenameFolder "PCB_UID_110173_UTR", "PCB_UID_110173_repl_token"

