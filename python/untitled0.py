# -*- coding: utf-8 -*-
"""
Created on Sun Apr 19 22:26:37 2026

@author: PinJung
"""

import numpy as np

# Each row is its own list [row1, row2]
matrix_A = np.array([[1,2],[3,4]])
matrix_B = np.array([[1,2],[4,1]])
times =matrix_A @ matrix_B
Dot =matrix_A * matrix_B
T=np.linalg.det(Dot)
print(T)