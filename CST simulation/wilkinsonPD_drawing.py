# -*- coding: utf-8 -*-
"""
Created on Tue Aug 25 12:28:48 2026

@author: mmwave
"""
get_ipython().run_line_magic('reset', '-sf') # noqa
import numpy as np

# %% trace1;
Width_T0 = 42.6; # microstrap width with 50 ohm impedance 
Width_T1 = 10.5549;# arc1 width with Z1 ohm impedance 
L1 = 255.54;# arc1 phase shift with 90 degree 
W_pad_x = 25.2;# 0402 pad size x 
W_pad_y = 21.26;# 0402 pad size x 
yc_pad= 20.08;# 0402 pad central y 
Y1_right = 20.08 #  y coordinate on the right side of arc1
X1_right = -1/2*W_pad_x+ 1/2*Width_T1  # x coordinate on the right side of arc1,align the left side of arc on the right side with the left side of pad

L1_m = L1-2*Y1_right- np.abs(X1_right) #calculate the arc1 length by subtracting the lengh of connection
R1_m =L1_m/np.pi;
X1_left = -2*R1_m+X1_right #calculate x coordinate on the left side of arc1
Y1_left =  Y1_right #calculate y coordinate on the left side of arc1
X1_C = X1_right - R1_m #calculate x coordinate on the center of arc1
Y1_C = Y1_left         #calculate y coordinate on the center of arc1
X_in = X1_left - Width_T0/2+Width_T1/2   #calculate x coordinate on the center of input pad
# print(f"X1_left={X1_left:.4f} mil,Y1_left={Y1_left:.4f} mil" )
# print(f"X1_right={X1_right:.4f} mil,Y1_right={Y1_right:.4f} mil" )
# print(f"X1_C={X1_C:.4f} mil,Y1_C={Y1_C:.4f} mil" )
# print(f"Xin={X_in:.4f} mil" )

# %%trace2;
Width_T2 = 13.88;
L2 = 253.7;
theta_trace_2 =3*np.pi/3 # define the angle of arc2 
theta_trace_2_degree = theta_trace_2*180/np.pi
X2_left=Width_T1/2+Width_T2/2+3.5+X1_right # calculate the x coordinate on the left side of arc2, with about 6 mil gap between the right edge of arc1 on the right side and the left edge of arc 2 on the left side
if Width_T2 < W_pad_x:
  Y2_right = yc_pad-W_pad_y/2+Width_T2/2# calculate the y coordinate  on the left side of arc2, with the end arc aligning with the bottom edge of 0402 pad.
else :
   Y2_right = yc_pad+Width_T2/2 # place the right side of the arc on the center of the R1 pad
   
Y2_left = Y2_right


L2_m = L2 - 2 * Y2_right - X2_left - (-Width_T2 / 2 + W_pad_x / 2)
R2_m = L2_m/theta_trace_2;
X2_right= X2_left + 2*R2_m*np.sin(1/2*theta_trace_2)
X2_C= X2_left + R2_m*np.sin(1/2*theta_trace_2)
Y2_C= Y2_left -R2_m*np.cos(1/2*theta_trace_2)
X_2R = X2_right-Width_T2/2+W_pad_x/2

# print(f"X2_left={X2_left:.4f} mil,Y2_left={Y2_left:.4f} mil" )
# print(f"X2_right={X2_right:.4f} mil,Y2_right={Y2_right:.4f} mil" )
# print(f"X2_C={X2_C:.4f} mil,Y2_C={Y2_C:.4f} mil" )
# print(f"incident angle = {theta_trace_2_degree:.5f} degree")
# print(f"X_2R = {X_2R:.5f} mil")


# %%trace3;
Width_T3 = 21.85;
L3 = 250.5;
theta_trace_3 =3*np.pi/3
theta_trace_3_degree = theta_trace_3*180/np.pi
X3_left=Width_T2/2+Width_T3/2+3.5+X2_right
Y3_left = yc_pad-W_pad_y/2+Width_T3/2
Y3_right= Y3_left

L3_m = L3 - 2 * Y3_right - (X3_left-X_2R) - (-Width_T3 / 2 + W_pad_x / 2)
R3_m = L3_m/theta_trace_3;
X3_right= X3_left + 2*R3_m*np.sin(1/2*theta_trace_3)
X3_C= X3_left + R3_m*np.sin(1/2*theta_trace_3)
Y3_C= Y3_left -R3_m*np.cos(1/2*theta_trace_3)
X_3R = X3_right-Width_T3/2+W_pad_x/2

# print(f"X3_left={X3_left:.4f} mil,Y3_left={Y3_left:.4f} mil" )
# print(f"X3_right={X3_right:.4f} mil,Y3_right={Y3_right:.4f} mil" )
# print(f"X3_C={X3_C:.4f} mil,Y3_C={Y3_C:.4f} mil" )
# print(f"X_3R = {X_3R:.5f} mil")
# print(f"incident angle = {theta_trace_3_degree:.5f} degree")

# %% trace4;
Width_T4 = 32.3;
L4 = 247.15;
theta_trace_4 =4*np.pi/5
theta_trace_4_degree = theta_trace_4*180/np.pi
X4_left=Width_T3/2+Width_T4/2+3.5+X3_right
Y4_left = yc_pad+W_pad_y/2
Y4_right= Y4_left

L4_m = L4 - 2 * Y4_right - (X4_left-X_3R) 
R4_m = L4_m/theta_trace_4;
X4_right= X4_left + 2*R4_m*np.sin(1/2*theta_trace_4)
X4_C= X4_left + R4_m*np.sin(1/2*theta_trace_4)
Y4_C= Y4_left -R4_m*np.cos(1/2*theta_trace_4)
X_4R = X4_right

# print(f"X4_left={X4_left:.4f} mil,Y4_left={Y4_left:.4f} mil" )
# print(f"X4_right={X4_right:.4f} mil,Y4_right={Y4_right:.4f} mil" )
# print(f"X4_C={X4_C:.4f} mil,Y4_C={Y4_C:.4f} mil" )
# print(f"X_4R = {X_4R:.5f} mil")
# print(f"incident angle = {theta_trace_4_degree:.5f} degree")

# %% trace5;
Width_T5 = 39.92
L5 = 245.22
theta_trace_5 =2*np.pi/3
theta_trace_5_degree = theta_trace_5*180/np.pi
X5_left=Width_T4/2+Width_T5/2+X4_right+3.5
Y5_left = yc_pad+W_pad_y/2
Y5_right= Y5_left

L5_m = L5 - 2 * Y5_right - (X5_left-X_4R) 
R5_m = L5_m/theta_trace_5;
X5_right= X5_left + 2*R5_m*np.sin(1/2*theta_trace_5)
X5_C= X5_left + R5_m*np.sin(1/2*theta_trace_5)
Y5_C= Y5_left -R5_m*np.cos(1/2*theta_trace_5)
X_5R = X5_right

print(f"X5_left={X5_left:.4f} mil,Y5_left={Y5_left:.4f} mil" )
print(f"X5_right={X5_right:.4f} mil,Y5_right={Y5_right:.4f} mil" )
print(f"X5_C={X5_C:.4f} mil,Y5_C={Y5_C:.4f} mil" )
print(f"X_5R = {X_5R:.5f} mil")
print(f"incident angle = {theta_trace_5_degree:.5f} degree")