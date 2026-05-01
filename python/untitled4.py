# -*- coding: utf-8 -*-
"""
Created on Tue Apr 21 02:02:54 2026

@author: PinJung

"""
from  IPython import get_ipython
get_ipython().run_line_magic('reset', '-sf')

n = 1.623449
R1 = 1.65
R2 = -R1
l1 = -0.33969305
t = 0.2
f1 = R1/2/(n-1)
print("f= %.3f m" % f1)
Phi1 = (n - 1) / R1
Phi2 = (1 - n) / R2

Phi = Phi1 + Phi2 - (t / n) * Phi1 * Phi2

f2 = 1 / Phi
print(f"Thick lens focal length f = {f2:.6f} m")
xc = 2.5
x0 = 1./(1/xc-1/f2)
x = 1.85
d = xc-x
y = 0.15
tanc=y/d
s = xc*tanc

