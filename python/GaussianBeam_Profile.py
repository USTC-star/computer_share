# -*- coding: utf-8 -*-
"""
Created on Mon Apr 20 23:42:14 2026

@author: PinJung
"""
import numpy as np
import matplotlib.pyplot as plt

# ---------- Parameters ----------
w0 = 1e-3          # waist at z = 0 (m)
lambda0 = 10.6e-6  # wavelength (m)
f = 0.2            # focal length (m)

# ---------- Initial q at waist ----------
zR = np.pi * w0**2 / lambda0
q0 = 1j * zR   # waist located at z = 0 (we will shift it later)

# ---------- ABCD matrices ----------
def lens(f):
    return np.array([[1, 0],
                     [-1/f, 1]])

def free_space(d):
    return np.array([[1, d],
                     [0, 1]])

# ---------- Define z range ----------
z_list = np.linspace(-0.6, 0.9, 500)  # include BEFORE lens (z<0)
w_list = []

# ---------- Assume waist is BEFORE lens ----------
z_waist_to_lens = 0.1  # distance from waist to lens (m)

for z in z_list:
    if z < 0:
        # before lens: only propagation from waist
        M = free_space(z + z_waist_to_lens)
    else:
        # after lens: propagate to lens, pass lens, then propagate
        M = free_space(z) @ lens(f) @ free_space(z_waist_to_lens)
    
    A, B = M[0, 0], M[0, 1]
    C, D = M[1, 0], M[1, 1]
    
    q = (A * q0 + B) / (C * q0 + D)
    
    inv_q = 1 / q
    w = np.sqrt(-lambda0 / (np.pi * np.imag(inv_q)))
    
    w_list.append(w)

# ---------- Plot ----------
plt.figure()
plt.plot(z_list, w_list)
plt.axvline(x=0, linestyle='--')  # lens position
plt.xlabel("z (m)")
plt.ylabel("Beam radius w(z) (m)")
plt.title("Gaussian Beam Propagation (Before and After Lens)")
plt.grid()

#plt.show()
