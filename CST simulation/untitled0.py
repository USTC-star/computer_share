# -*- coding: utf-8 -*-
"""
Created on Sun Sep 20 04:04:46 2026

@author: PinJung
"""

from dynamic_runaway4_loop_Energy_3_numba import run_simulation

result = run_simulation(
    nt_override=1_000_000,
    verbose=True,
    make_plots=True
)