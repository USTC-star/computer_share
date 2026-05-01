# -*- coding: utf-8 -*-
"""
Created on Tue Apr 28 01:08:58 2026

@author: PinJung
"""

import numpy as np
import matplotlib.pyplot as plt

def space(d):
    return np.array([[1, d], [0, 1]])

def lens(f):
    return np.array([[1, 0], [-1/f, 1]])

def trace_ray(ray, system):
    for M in system:
        ray = M @ ray
    return ray

# Optical system
f = 0.1
system = [
    space(0.2),
    lens(f)
]

# Scan
y_obj_list = np.linspace(-2e-0, 2e-0, 100)
z_scan = np.linspace(0.05, 0.5, 200)

focus_positions_z = []
focus_positions_y = []

for y_obj in y_obj_list:
    min_spot = 1e9
    best_z = None

    for z in z_scan:
        full_system = system + [space(z)]

        rays = [
            np.array([y_obj,  0.0]),
            np.array([y_obj,  0.01]),
            np.array([y_obj, -0.01])
        ]

        y_out = [trace_ray(ray, full_system)[0] for ray in rays]
        spot = np.std(y_out)
        

        if spot < min_spot:
            min_spot = spot
            best_z = z
            best_yout = np.mean(y_out)

    focus_positions_z.append(best_z)
    focus_positions_y.append(best_yout)

print(focus_positions_z)
plt.plot(focus_positions_z,focus_positions_y,'.')