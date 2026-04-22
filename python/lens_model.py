# -*- coding: utf-8 -*-
"""
Created on Sun Mar 15 14:42:47 2026

@author: PinJung
"""
"Develope the first temple for MIR lens "
import numpy as np
import matplotlib.pyplot as plt
import math



theta1=math.atan(-0.16766)
n = 1.623449
r1 = 1.65
r2 = -r1
l1 = -0.33969305
d = 1e-3*(4019.67893-3889.25589)
#d = 0.0
P1 = -(n-1)/n/r1
P3 = -(1-n)/1/r2

M1 = np.array([[1,0],[P1,1/n]])
M2 = np.array([[1,d],[0,1]])
M3 = np.array([[1,0],[P3,n]])

Ma=(M2@M1)
M= M3@Ma

Pin = np.array([[l1],[theta1]])
Pout = M @ Pin
Tantheta2 = math.tan(Pout[1,0])
