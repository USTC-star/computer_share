# -*- coding: utf-8 -*-
"""
Created on Fri Apr 24 00:03:43 2026

@author: PinJung
"""

from  numerical_optical_simulation import GaussianBeam,Thicklens,SpaceMatrix,OpticalMatrix
import numpy as np
import matplotlib.pyplot as plt
beam = GaussianBeam(w0=8*1e-3, lambda0=3.333333*1e-3)
lens1= Thicklens(r1=1e99,r2=-2,d=0.1,n=1.623450)
lens2= Thicklens(r1=2,r2=1e99,d=0.1,n=1.623450)
lens3= Thicklens(r1=-0.6,r2=1e99,d=0.1,n=1.623450)
lens4= Thicklens(r1=-0.9,r2=1e99,d=0.1,n=1.623450)
lens5= Thicklens(r1=1.65,r2=-1.65,d=0.2,n=1.623450)
lens6= Thicklens(r1=1e99,r2=1e99,d=0.044,n=1.623450)
space1 = SpaceMatrix(0.4)
space3 = SpaceMatrix(0.05)
ds = np.linspace(0.01,2.9,500)
xc = 2.4-0.094
delta_xi=[]
for di in ds:
    space2 = SpaceMatrix(di)
    M2 = lens6.Matrix@space3.Matrix@lens5.Matrix@space2.Matrix@lens4.Matrix
    optics2 = OpticalMatrix(M2)
    xi = optics2.transform_raytrace(-1e99)
    delta_xi.append(xi-xc)

plt.plot(ds,delta_xi)

min_idx = np.argmin(np.abs(delta_xi))
min_val = delta_xi[min_idx]

print(ds[min_idx])
