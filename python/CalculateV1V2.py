# -*- coding: utf-8 -*-
"""
Created on Thu May 28 12:32:35 2026

@author: mmwave
"""
import numpy as np
R1 = 17.4*1e3
R2 = 1.0*1e3
Rk = 1E3 
V1= 12 * R2 / (R1 + R2 + Rk)    
V2= 12 * (R2 + Rk) / (R1 + R2 + Rk) 

#Calculate R1 R2
Rk = 1000.0   # Fixed resistor Rk in ohms

# ==========================================
# Read Excel file
# ==========================================


# Read V1 and V2 columns
V1 = 7
V2 = 9

# ==========================================
# Calculate R1 and R2
# Equations:
#   12 * R2 / (R1 + R2 + Rk)     = V1
#   12 * (R2 + Rk) / (R1 + R2 + Rk) = V2
#
# Analytical solution:
#   R2 = V1 * Rk / (V2 - V1)
#   S  = R1 + R2 + Rk = 12 * Rk / (V2 - V1)
#   R1 = S - R2 - Rk
# ==========================================
den = V2 - V1

# Calculate R2, avoid division by zero
R2= np.where(den != 0, V1 * Rk / den, np.nan)

# Calculate total resistance S = R1 + R2 + Rk
S = np.where(den != 0, 12.0 * Rk / den, np.nan)

# Calculate R1
R1 = S - R2 - Rk

# ==========================================
# Save results to a new Excel file
# ==========================================
df.to_excel(output_path, index=False)