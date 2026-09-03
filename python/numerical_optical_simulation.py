# -*- coding: utf-8 -*-
"""
Created on Wed Apr 22 22:45:50 2026

@author: Xinhang Xu
"""

import numpy as np
import matplotlib.pyplot as plt
import math
class GaussianBeam:
    def __init__(self, w0, lambda0):
        self.w0 = w0
        self.lambda0 = lambda0
        self.zR0 = np.pi * w0**2 / lambda0


    def q_at_distance(self, z):
        """Return q parameter at distance z from waist"""
        w = self.w0*np.sqrt(1+(z/self.zR0)**2)
        zR = np.pi*w**2 / self.lambda0
        return z + 1j*zR


class ThinLens:
    def __init__(self,r1,r2,n):
        inv_f = 1/r1*(n-1)-1/r2*(n-1)
        self.f = 1/inv_f
        self.Matrix = np.array([[1,0],[-1/self.f,1]])
    @classmethod
    def set_focal_length(cls, f):
        obj = cls(r1=1, r2=-1, n=2)  # dummy values, won't be used
        obj.f = f
        obj.Matrix = np.array([[1, 0], [-1/f, 1]])
        return obj
class Mirror:
    def __init__(self,ry,rx):
        inv_fx = -2/rx
        inv_fy = -2/ry
        self.fx = 1/inv_fx
        self.fy = 1/inv_fy
        self.Matrix_x = np.array([[1,0],[-1/self.fx,1]])
        self.Matrix_y = np.array([[1, 0], [-1 / self.fy, 1]])
        
class Thicklens:
    def __init__(self,r1,r2,d,n):
        M1 = np.array([[1, 0], [(1 - n)/(r1*n), 1/n]])
        M2 = np.array([[1, d], [0, 1]])
        M3 = np.array([[1, 0], [(n - 1)/r2, n]])
        # refraction at surface 1 (air -> glass)
        self.Matrix = M3@M2@M1
        self.M11,self.M12 = self.Matrix[0]
        self.M21,self.M22 = self.Matrix[1]
        self.h1 = (1-self.M22)/self.M21
        self.h2 = (1-self.M11)/self.M21
        self.f  = -1/self.M21
        self.f_h1 = -self.f - self.h1 
        self.f_h2 = self.f + self.h2
        self.P = (n-1)/n/r1+(1-n)/r2

class OpticalMatrix:
    def __init__(self,Mtotal):
        self.M11,self.M12 = Mtotal[0]
        self.M21,self.M22 = Mtotal[1]
        self.h1 = (1-self.M22)/self.M21
        self.h2 = (1-self.M11)/self.M21
        self.f  = -1/self.M21
        self.f_h1 = -self.f - self.h1 
        self.f_h2 = self.f + self.h2
        self.Matrix = Mtotal
    def transform_gaussian(self, q_in):
        """Apply lens transformation"""
        q_out = (q_in*self.M11+self.M12)/(self.M21*q_in+self.M22)
        return q_out
    def transform_raytrace(self,x0):
        x0_H1 = x0+self.h1
        inv_H2_xi = 1/self.f + 1/x0_H1
        xi = 1/inv_H2_xi + self.h2
        return xi
        
class SpaceMatrix:
    def __init__(self,z):
        self.Matrix = np.array([[1,z],[0,1]])

class OpticalSystem:
    def __init__(self, beam, optics, z):
        self.beam = beam
        self.optics = optics
        self.z = z   # waist → lens distance

    def compute_new_waist(self):
        # q at lens
        q_in = self.beam.q_at_distance(self.z)

        # through lens
        q_out = self.optics.transform_gaussian(q_in)

        # extract waist
        z_new = -np.real(q_out)
        zr0_new = np.imag(q_out)
        w0_new = np.sqrt(self.beam.lambda0 * zr0_new / np.pi)
        w_new  = np.sqrt(self.beam.lambda0/np.pi*(-1)/np.imag(1/q_out))
        inv_R = np.real(1 / q_out)
        R_cur = 1 / inv_R
        return z_new*1e3, w0_new*1e3, w_new*1e3, R_cur*1e3

    


def main():
# ---------- Example ----------
    beam = GaussianBeam(w0=8*1e-3, lambda0=3.333333*1e-3)
    # lens = ThinLens(r1=0.1, r2=-0.1, n=1.623450)
    lens2 = Thicklens(r1=0.1, r2=-0.1, d=0.1, n=1.623450)
    optics = OpticalMatrix(lens2.Matrix)
    system = OpticalSystem(beam, optics, z=0.16)
    z_new, w0_new = system.compute_new_waist()
    
    s = np.linspace(0.01, 0.94,100)
    f_list = []
    # lens1= ThinLens.set_focal_length(20e-2)
    # lens2= ThinLens.set_focal_length(20e-2)
    lens1= Thicklens(r1=1e99,r2=-2,d=0.18,n=1.623450)
    lens2= Thicklens(r1=2,r2=1e99,d=0.15,n=1.623450)
    lens3= Thicklens(r1=-0.6,r2=1e99,d=0.1,n=1.623450)
    len_thin=ThinLens.set_focal_length(10)
    print("len_thin:%.3f m" % len_thin.f)
    for sj in s :
    
        space =SpaceMatrix(sj)
        
        M = lens2.Matrix@space.Matrix@lens1.Matrix
        optics1 = OpticalMatrix(M)
        f_list.append(optics1.f)
    plt.plot(s,f_list)
    plt.xlabel("spacing (m)")
    plt.ylabel("effective focal length")
    plt.show()
    
    space =SpaceMatrix(0.4)
    
    M = lens2.Matrix@space.Matrix@lens1.Matrix
    optics1 = OpticalMatrix(M)
    
    H1 = optics1.h1*1e2
    H2 = optics1.h2*1e2
    xi = optics1.transform_raytrace(-1e99)
    optics2 = OpticalMatrix(lens3.Matrix)
    
    H2 = optics2.h2*1
    # f_infinity = optics2.transform_raytrace(-1e99)
    f_h = optics2.f + H2
    
    delatD = xi +f_h
    
    print("New waist position:%.9f mm"% z_new)
    print("New waist size:%.9f mm"% w0_new)
    print("thicklens foucs length f = :%.4f m" % optics.f)
    print("thicklens matrix :" , lens2.Matrix)
    print("H1:%.9f cm"% H1)
    print("H2:%.9f cm"% H2)
    print("xi:%.9f cm"% xi)
    print("f3:%.9f m"% lens3.f)
    print("deltaD:%.9f m"% delatD)
if __name__ == "__main__":
        main()