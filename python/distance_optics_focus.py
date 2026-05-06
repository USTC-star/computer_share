# -*- coding: utf-8 -*-
"""
Created on Mon Apr 27 02:10:58 2026

@author: PinJung
"""
from  numerical_optical_simulation import GaussianBeam,Thicklens,SpaceMatrix,OpticalMatrix
import numpy as np
import matplotlib.pyplot as plt

beam = GaussianBeam(w0=8*1e-3, lambda0=3.333333*1e-3)
lens1= Thicklens(r1=1e99,r2=-2,d=0.1,n=1.623450)
lens2= Thicklens(r1=2,r2=1e99,d=0.1,n=1.623450)
lens3= Thicklens(r1=1E99,r2=0.6,d=0.1,n=1.623450)
lens4= Thicklens(r1=-0.9,r2=1e99,d=0.1,n=1.623450)
lens5= Thicklens(r1=1.65,r2=-1.65,d=0.2,n=1.623450)
lens6= Thicklens(r1=1e99,r2=-1e99,d=0.044,n=1.623450)
space = SpaceMatrix(0.05)
M = lens5.Matrix@space.Matrix@lens6.Matrix
optics = OpticalMatrix(M)
xi=-2.4+0.044+0.05
x0 = optics.transform_raytrace(xi)

optics4 = OpticalMatrix(lens4.Matrix)
xd = optics4.transform_raytrace(-1e99)
x=x0+xd
f4h2=optics4.f_h2



space2 = SpaceMatrix(x)
M = lens6.Matrix@space.Matrix@lens5.Matrix@space2.Matrix@lens4.Matrix
optics=OpticalMatrix(M)
xi_end = optics.transform_raytrace(-1e99)



lensa= Thicklens(r1=-1,r2=-1e99,d=0.09,n=1.623450)
lensb= Thicklens(r1=-1,r2=1E99,d=0.09,n=1.623450)
lensc= Thicklens(r1=0.7,r2=1e99,d=0.15,n=1.623450)
fc = -lensc.f_h1
ds=np.linspace(0.1,1,100)
fh2s=[]
for d in ds:
    space = SpaceMatrix(d)
    M = lensb.Matrix@space.Matrix@lensa.Matrix
    optics = OpticalMatrix(M)
    fh2s.append(optics.f_h2)
    
plt.figure

plt.plot(ds,fh2s)

plt.xlabel('space/m')
plt.ylabel('f/m')

print("fc=%.2fm"% fc)

plt.show()


Amp = []
d2d = []

for d in ds:
    space = SpaceMatrix(d)
    M = lensb.Matrix@space.Matrix@lensa.Matrix
    optics = OpticalMatrix(M)
    fs = optics.f_h2
    space2 = SpaceMatrix(fc+fs)
    M2 = lensc.Matrix@space2.Matrix@lensb.Matrix@space.Matrix@lensa.Matrix
    Amp.append( M2[0,0])
    d2d.append(fs+fc)
    
fig, ax1 = plt.subplots()
ax1.plot(ds,Amp,label="Amp",color='blue')

ax1.set_xlabel('space/m')
ax1.set_ylabel('Amp')
ax1.tick_params(axis='y', labelcolor='blue')
# Right y-axis
ax2 = ax1.twinx()
ax2.plot(ds,d2d,color='red',label="distance",linestyle='--')
ax2.tick_params(axis='y', labelcolor='red')
ax2.set_ylabel('distance(m)')


lines1, labels1 = ax1.get_legend_handles_labels()
lines2, labels2 = ax2.get_legend_handles_labels()

ax1.legend(lines1 + lines2, labels1 + labels2, loc='best')

plt.show()



space = SpaceMatrix(0.3)
M = lensb.Matrix@space.Matrix@lensa.Matrix
optics = OpticalMatrix(M)
fs = optics.f_h2
space2 = SpaceMatrix(fc+fs)
M2 = lensc.Matrix@space2.Matrix@lensb.Matrix@space.Matrix@lensa.Matrix
optics_zoom = OpticalMatrix(M2)
xi_end = optics_zoom.transform_raytrace(-1e99)
d2d=(fc+fs)*1e3
AMP = M2[0,0]
print('d2d = %.7f mm90, Amp = %.4f' % (d2d, AMP))