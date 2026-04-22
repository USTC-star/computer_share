# -*- coding: utf-8 -*-
"""
Created on Wed Apr 22 00:37:07 2026

@author: PinJung
"""

n = 1.623449
R1 = -0.900
R2 = 1e9
t = 0.1
f1 = R1/1/(n-1)
print("f= %.3f m" % f1)
Phi1 = (n - 1) / R1
Phi2 = (1 - n) / R2

Phi = Phi1 + Phi2 - (t / n) * Phi1 * Phi2

f2 = 1 / Phi
print("f2= %.3f m" % f2)