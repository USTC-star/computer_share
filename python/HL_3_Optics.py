# -*- coding: utf-8 -*-
"""
Created on Fri Apr 24 00:03:43 2026

@author: PinJung
"""

from  numerical_optical_simulation import GaussianBeam,Thicklens,SpaceMatrix,OpticalMatrix,OpticalSystem
import numpy as np
import matplotlib.pyplot as plt
import math
# beam = GaussianBeam(w0=8*1e-3, lambda0=3.333333*1e-3)
# lens1= Thicklens(r1=1e99,r2=-2,d=0.1,n=1.623450)
# lens2= Thicklens(r1=2,r2=1e99,d=0.1,n=1.623450)
# lens3= Thicklens(r1=-0.6,r2=1e99,d=0.1,n=1.623450)
# lens4= Thicklens(r1=-0.9,r2=1e99,d=0.1,n=1.623450)
# lens5= Thicklens(r1=1.65,r2=-1.65,d=0.2,n=1.623450)
# lens6= Thicklens(r1=1e99,r2=1e99,d=0.044,n=1.623450)
# space1 = SpaceMatrix(0.4)
# space3 = SpaceMatrix(0.05)
# ds = np.linspace(0.01,2.9,500)
# xc = 2.4-0.094
# delta_xi=[]
# for di in ds:
#     space2 = SpaceMatrix(di)
#     M2 = lens6.Matrix@space3.Matrix@lens5.Matrix@space2.Matrix@lens4.Matrix
#     optics2 = OpticalMatrix(M2)
#     xi = optics2.transform_raytrace(-1e99)
#     delta_xi.append(xi-xc)
#
# plt.plot(ds,delta_xi)
#
# min_idx = np.argmin(np.abs(delta_xi))
# min_val = delta_xi[min_idx]
#
# print(ds[min_idx])
# %%
first_lens = Thicklens(r1=1.55,r2=-1.55,d=0.260,n=1.623450)
h_first_lens = 0.55
optics = OpticalMatrix(first_lens.Matrix)
x0 = 2.1
R_cutoff = 0.55
xi = optics.transform_raytrace(-x0)
print('xi=%.4fm' %xi)
print(f"xi = {xi:.4f} m")
h_cutoff = (h_first_lens - 0.06)/x0*R_cutoff
print(f"h_cutoff = {h_cutoff:.4f} m")
alpha_0 = math.atan(0.528/xi)
print(f"alpha_0 = {alpha_0:.4f} rad")

# beam = GaussianBeam(w0=8*1e-3, lambda0=3.333333*1e-3)
# system = OpticalSystem(beam, optics, z=-1.01)
# z_new, w0_new = system.compute_new_waist()
# print("z_new=%.4fm, w0_new = %.2fmm"%(z_new, w0_new))

# f2_list = []
# f2h_list= []
# alphai_list=[]
zoom1 = Thicklens(r1=1,r2=-1e99,d=0.1,n=1.623450)
zoom2 = Thicklens(r1=1,r2=-1e99,d=0.1,n=1.623450)


L0 = np.array([[0.146], [0]])

d_antenna_zoom1 = 0.140
space0 = SpaceMatrix(d_antenna_zoom1)
s = 0.8
space = SpaceMatrix(s)
s2 = 0.45+3
space2 = SpaceMatrix(s2)
optics_new = OpticalMatrix(first_lens.Matrix@space2.Matrix@zoom2.Matrix@space.Matrix@zoom1.Matrix@space0.Matrix)
print('optics.fh2=%.4f m'%optics_new.f_h2)
dcutoff = optics_new.f_h2 -R_cutoff
print(f"Dcutoff= {dcutoff:.4f} ")
L = SpaceMatrix(dcutoff).Matrix@optics_new.Matrix@L0
print(f" z= {L[0,0]*1e3:.7f}mm ")

# Scan s2 while keeping the distance between zoom1 and the first lens fixed.
# For each s2 position, s1 is adjusted so that s1 + s2 remains constant.
s1_s2_total = s + s2
s2_scan = np.linspace(0.01, s1_s2_total - 0.01, 100)
s1_scan = s1_s2_total - s2_scan
f_h2_scan = []
dcutoff_scan = []

for s2_value, s1_value in zip(s2_scan, s1_scan):
    scan_space1 = SpaceMatrix(s1_value)
    scan_space2 = SpaceMatrix(s2_value)
    scan_optics = OpticalMatrix(
        first_lens.Matrix
        @ scan_space2.Matrix
        @ zoom2.Matrix
        @ scan_space1.Matrix
        @ zoom1.Matrix
        @ space0.Matrix
    )
    f_h2_scan.append(scan_optics.f_h2)
    dcutoff_scan.append(scan_optics.f_h2 - R_cutoff)

plt.figure()
plt.plot(s2_scan, dcutoff_scan)
plt.xlabel("S2 distance (m)")
plt.ylabel("Cutoff distance (m)")
plt.grid()
plt.show()

# %%
# f2_list = []
# f2h_list = []
#
#
# lambda0 = 4*1e-3
# w0 = 22*1e-3
# beam = GaussianBeam(w0=w0, lambda0=lambda0)
# system = OpticalSystem(beam, optics_new, z=0)
#
# z_new, w0_new, w_new = system.compute_new_waist()
# zR=np.pi*(w_new*1E-3)**2/lambda0
# print("z_new=%.4fm, w0_new = %.4fmm,w_new = %.4fmm zR=%.4f m"%(z_new, w0_new,w_new,zR))
# print('z_cutoff = %.4f m '%(optics.f_h2-0.550))


# d_antenna_zoom1 = 0.140
# space0 = SpaceMatrix(d_antenna_zoom1)
# s1 = np.linspace(0.01, 1.3,100)
# L_obj_1stlens = 4.590
# L_fixed = 0.14+0.1+0.1
# L_cutoff = 1.5429
# f2_list = []
# f2h_list = []
# R_list = []
# z_new_list = []
# w0_new_list = []
# w_new_list = []
# z_R_list= []
# lambda0 = 4 * 1e-3
# w0 = 22 * 1e-3
# for s in s1:
#   space = SpaceMatrix(s)
#   s2 = L_obj_1stlens - L_fixed-s
#   space2 = SpaceMatrix(s2)
#   optics = OpticalMatrix(SpaceMatrix(L_cutoff).Matrix@first_lens.Matrix@space2.Matrix@zoom2.Matrix@space.Matrix@zoom1.Matrix@space0.Matrix)
#   f2h_list.append(optics.f_h2)
#   R_list.append(optics.f_h2)
#
#   beam = GaussianBeam(w0=w0, lambda0=lambda0)
#   system = OpticalSystem(beam, optics, z=0)
#   z_new, w0_new,w_new = system.compute_new_waist()
#   zR=np.pi*(w0_new*1E-3)**2/lambda0
#   z_R_list.append(zR)
#   z_new_list.append(z_new)
#   w0_new_list.append(w0_new)
#   w_new_list.append(w_new)
#   print("z_new=%.4fm, w0_new = %.2fmm,w_new=%.4fmm zR=%.4f m"%(z_new, w0_new,w_new,zR))
#
# plt.figure(3)
# plt.plot(s1,R_list,'r-')
# plt.xlabel("Distance from zoom1 to zoom2 (m)")
# plt.ylabel("R (m)")
# plt.show()
# plt.figure(4)
# plt.plot(s1,z_R_list,'b-')
# plt.xlabel("Distance from zoom1 to zoom2 (m)")
# plt.ylabel("z_R (m)")
# plt.show()
# plt.figure(5)
# plt.plot(s1,z_new_list,'b-')
# plt.xlabel("Distance from zoom1 to zoom2 (m)")
# plt.ylabel("z_new (m)")
# plt.show()
# plt.figure(6)
# plt.plot(s1,w_new_list,'b-')
# plt.xlabel("Distance from zoom1 to zoom2 (m)")
# plt.ylabel("w (m)")
# plt.show()
# plt.figure(7)
# plt.plot(s1,w0_new_list,'b-')
# plt.xlabel("Distance from zoom1 to zoom2 (m)")
# plt.ylabel("w0 (m)")
# plt.show()
# %% illumination optics
s3 = 2.379
s2 = 0.200
s1 = 0.1
s4 = 0.2
s5 = 1.323


space1 = SpaceMatrix(s1)
space2 = SpaceMatrix(s2)
space3 = SpaceMatrix(s3)
space4 = SpaceMatrix(s4)
space5 = SpaceMatrix(s5)
first_lens = Thicklens(r1=1.55,r2=-1.55,d=0.260,n=1.623450)
gain_lens = Thicklens(r1=-0.4,r2=1e99,d=0.040,n=1.623450)
zoom_lens = Thicklens(r1= 1,r2= -1,d=0.040,n=1.623450)
window_lens = Thicklens(r1= 1e99,r2= -1e99,d=0.044,n=1.623450)
optics = OpticalMatrix(space5.Matrix
                       @window_lens.Matrix
                       @space4.Matrix
                       @first_lens.Matrix
                        @space3.Matrix
                       @zoom_lens.Matrix
                        @space2.Matrix
                        @gain_lens.Matrix
                        @space1.Matrix)

lambda0 = 4*1e-3
w0 = 8*1e-3
beam = GaussianBeam(w0=w0, lambda0=lambda0)
system = OpticalSystem(beam, optics, z=0)

z_new, w0_new, w_new ,R_cur = system.compute_new_waist()
zR=np.pi*(w_new*1E-3)**2/lambda0
print("z_new=%.4fmm, w0_new = %.4fmm,w_new = %.4fmm zR=%.4f m,R_cur=%.4f mm"%(z_new, w0_new,w_new,zR,R_cur))
print('z_cutoff = %.4f m '%(optics.f_h2-0.550))

# %% scanning the code
# Scan s2 while keeping the distance between horn and the first lens fixed.
# For each s2 position, s3 is adjusted so that s1 + s2 remains constant.
d_horn_1stlens = 2.679
s1 = 0.1
s4 = 0.2
s5 = 1.323
space1 = SpaceMatrix(s1)
space2 = SpaceMatrix(s2)
space3 = SpaceMatrix(s3)
space4 = SpaceMatrix(s4)
space5 = SpaceMatrix(s5)
first_lens = Thicklens(r1=1.55,r2=-1.55,d=0.260,n=1.623450)
gain_lens = Thicklens(r1=-0.4,r2=1e99,d=0.040,n=1.623450)
zoom_lens = Thicklens(r1= 1,r2= -1,d=0.040,n=1.623450)
window_lens = Thicklens(r1= 1e99,r2= -1e99,d=0.044,n=1.623450)


s2_scan = np.linspace(0.01,0.2, 30)
s3_scan = d_horn_1stlens -s1-s2_scan

R_cur_scan = []
w_new_scan = []
lambda0 = 4*1e-3
w0 = 8*1e-3
beam = GaussianBeam(w0=w0, lambda0=lambda0)

for s2_value, s3_value in zip(s2_scan, s3_scan):
    scan_space3 = SpaceMatrix(s3_value)
    scan_space2 = SpaceMatrix(s2_value)

    scan_optics = OpticalMatrix(space5.Matrix
                       @window_lens.Matrix
        @space4.Matrix
        @first_lens.Matrix
        @ scan_space3.Matrix
        @ zoom_lens.Matrix
        @ scan_space2.Matrix
        @ gain_lens.Matrix
        @ space1.Matrix
    )
    system = OpticalSystem(beam, scan_optics, z=0)
    z_new, w0_new, w_new, R_cur = system.compute_new_waist()
    R_cur_scan.append(-1*R_cur)
    w_new_scan.append(w_new)

fig, ax_radius = plt.subplots()
ax_beam = ax_radius.twinx()

ax_radius.plot(s2_scan * 1e3, R_cur_scan,'*-', color="tab:blue", label="Wavefront radius")
ax_beam.plot(s2_scan * 1e3, w_new_scan,"o-", color="tab:orange", label="Beam radius")

ax_radius.set_xlabel("S2 distance (mm)")
ax_radius.set_ylabel("Wavefront Radius (mm)", color="tab:blue")
ax_beam.set_ylabel("Beam Radius (mm)", color="tab:orange")
ax_radius.set_title(f"s1 = {s1 * 1e3:.0f} mm")
ax_radius.tick_params(axis="y", labelcolor="tab:blue")
ax_beam.tick_params(axis="y", labelcolor="tab:orange")
ax_radius.grid()
fig.tight_layout()
plt.show()
