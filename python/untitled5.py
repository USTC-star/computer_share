# -*- coding: utf-8 -*-
"""
Created on Fri Apr 24 00:03:43 2026

@author: PinJung
"""

from  numerical_optical_simulation import GaussianBeam,Thicklens
beam = GaussianBeam(w0=8*1e-3, lambda0=3.333333*1e-3)
lens2 = Thicklens(r1=0.1, r2=-0.1, d=0.1, n=1.623450)
