# -*- coding: utf-8 -*-
"""
Created on Mon Apr 27 02:10:58 2026

@author: PinJung
"""
from  numerical_optical_simulation import GaussianBeam,Thicklens,SpaceMatrix,OpticalMatrix

beam = GaussianBeam(w0=8*1e-3, lambda0=3.333333*1e-3)
lens1= Thicklens(r1=1e99,r2=-2,d=0.1,n=1.623450)
lens2= Thicklens(r1=2,r2=1e99,d=0.1,n=1.623450)
lens3= Thicklens(r1=1E99,r2=0.6,d=0.1,n=1.623450)
lens4= Thicklens(r1=-0.9,r2=1e99,d=0.1,n=1.623450)
lens5= Thicklens(r1=1.65,r2=-1.65,d=0.2,n=1.623450)
space = SpaceMatrix(0.4)
M = lens2.Matrix@space.Matrix@lens1.Matrix
optics1 = OpticalMatrix(M)
H1_1 = optics1.h1
H1_2 = optics1.h2
xi = optics1.transform_raytrace(-1e99)
optics2 = OpticalMatrix(lens3.Matrix)

H2_2 = optics2.h2*1
H2_1 = optics2.h1*1
# f_infinity = optics2.transform_raytrace(-1e99)
f_h = optics2.f + H2_1
delatD = xi - optics2.f_h1
print("deltaD:%.9f m"% delatD)