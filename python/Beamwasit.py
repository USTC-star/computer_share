# -*- coding: utf-8 -*-
"""
Created on Tue Apr 21 00:57:08 2026

@author: PinJung
"""

import numpy as np

def gaussian_beam_after_lens(w0, lambda0, f, z):
    """
    w0: initial waist radius (m)
    lambda0: wavelength (m)
    f: focal length (m)
    z: distance from initial waist to lens (m)
    """

    # Rayleigh range
    zR = np.pi * w0**2 / lambda0

    # q at lens
    q_in = z + 1j * zR

    # lens transformation
    q_out = q_in / (1 - q_in / f)

    # extract new waist
    z_new = -np.real(q_out)           # position after lens
    zR_new = np.imag(q_out)
    w0_new = np.sqrt(lambda0 * zR_new / np.pi)

    return z_new, w0_new


# ---------- Example ----------
w0 = 1e-3
lambda0 = 10.6e-6
f = 0.1
z = 0.2   # waist is 0.2 m before lens

z_new, w0_new = gaussian_beam_after_lens(w0, lambda0, f, z)

print("New waist position (m):", z_new)
print("New waist radius (m):", w0_new)