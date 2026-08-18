# -*- coding: utf-8 -*-
"""
Created on Mon Apr 27 02:10:58 2026

@author: PinJung
"""

from  numerical_optical_simulation import GaussianBeam,Thicklens,SpaceMatrix,OpticalMatrix
import numpy as np
import matplotlib.pyplot as plt

# lensa = Thicklens(r1=-1.2, r2=1.2, d=0.1, n=1.623450)
# lensb = Thicklens(r1=1e99, r2=-1e99, d=0.0, n=1.00001)
# lensc = Thicklens(r1=1.2, r2=1e99, d=0.1, n=1.623450)
# fc = -lensc.f_h1
# ds = np.linspace(0.1, 1, 100)
# fh2s = []
# for d in ds:
#     space = SpaceMatrix(d)
#     M = lensb.Matrix @ space.Matrix @ lensa.Matrix
#     optics = OpticalMatrix(M)
#     fh2=optics.f_h2
#     fh2s.append(optics.f_h2)
#
# plt.figure(1)
#
# plt.plot(ds, fh2s)
#
# plt.xlabel('space/m')
# plt.ylabel('f/m')
# d = fc+fh2
# print("fc=%.2fm,fh2=%.2fm,d=%.2fm" %(fc,fh2,d))
#
# Amp = []
# d2d = []
#
# for d in ds:
#     space = SpaceMatrix(d)
#     M = lensb.Matrix @ space.Matrix @ lensa.Matrix
#     optics = OpticalMatrix(M)
#     fs = optics.f_h2
#     space2 = SpaceMatrix(fc + fs)
#     print("fs=%.2fm,fc=%.2fm,d=%.2fm" %(fs,fc,fc + fs))
#     M2 = lensc.Matrix @ space2.Matrix @ lensb.Matrix @ space.Matrix @ lensa.Matrix
#     Amp.append(M2[0, 0])
#     d2d.append(fs + fc)
#
# fig, ax1 = plt.subplots()
# ax1.plot(ds, Amp, label="Amp", color='blue')
#
# ax1.set_xlabel('space/m')
# ax1.set_ylabel('Amp')
# ax1.tick_params(axis='y', labelcolor='blue')
# # Right y-axis
# ax2 = ax1.twinx()
# ax2.plot(ds, d2d, color='red', label="distance", linestyle='--')
# ax2.tick_params(axis='y', labelcolor='red')
# ax2.set_ylabel('distance(m)')
#
# lines1, labels1 = ax1.get_legend_handles_labels()
# lines2, labels2 = ax2.get_legend_handles_labels()
#
# ax1.legend(lines1 + lines2, labels1 + labels2, loc='best')
#
# plt.show()

lensa = Thicklens(r1=-1.2, r2=1e99, d=0.08, n=1.623450)
lensc = Thicklens(r1=1.3, r2=1e99, d=0.1, n=1.623450)
fc = -lensc.f_h1
fa = lensa.f_h2
d = fc+fa
space = SpaceMatrix(d)
M = lensc.Matrix @ space.Matrix @ lensa.Matrix

Amp=M[0, 0]
print("fc = %.2fm,fa = %.2fm,d=%.2fm,AMP=%.2fm" % (fc,fa,d,Amp))
