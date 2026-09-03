# -*- coding: utf-8 -*-
"""
Created on Tue Aug 25 12:28:48 2026

@author: Xinhang Xu
"""
get_ipython().run_line_magic('reset', '-sf') # noqa
import numpy as np

W_pad_x = 25.2;# 0402 pad size x 
W_pad_y = 21.26;# 0402 pad size x 
yc_pad= 20.08;# 0402 pad central y 
xc_pad= 0;# 0402 pad central 0 
d_gap = 4 # The spacing between two neighboring rings
# %% trace1;
Width_T0 = 42 ; # microstrap width with 50 ohm impedance 
Width_T1 = 14.39;# arc1 width with Z1 ohm impedance L1 = 213.23;# arc1 phase shift with 90 degree 
L1 = 213.23
theta_trace_1 =3*np.pi/4 # define the angle of arc2 
theta_trace_1_degree = theta_trace_1*180/np.pi
Width_T=Width_T1
if Width_T<W_pad_x:    
    if Width_T<W_pad_y:         
        Y_right =  yc_pad # align the y coordinate on the right side of arc1 with the center of the pad
    else:
        Y_right =  yc_pad-W_pad_y/2+Width_T/2# align the y coordinate on the right side of arc1 with the end of the pad
     
    X_right = -1/2*W_pad_x+ 1/2*Width_T  # x coordinate on the right side of arc,align the left edge 
                                           # of the arc with the left edge of the pad
else:   
    R = Width_T/2
    l = W_pad_x/2
    d = R-np.sqrt(R**2-l**2)
    if d < W_pad_y:
        Y_right =  yc_pad+W_pad_y/2-d+ Width_T/2 #align the end of the arc on the the pad in vertical direction
    else: 
        Y_right =  yc_pad-W_pad_y/2+Width_T/2 #align the end of the arc on the bottom of the pad
    X_right = xc_pad  # x coordinate on the right side of arc1,align the end
                      # of the arc on the center of the pad in the horizonal direction
 
Y1_right  =   Y_right
X1_right  =   X_right                                                                           
L1_m = L1-2*Y1_right- np.abs(X1_right) #calculate the arc1 length by subtracting the lengh of 
                                       #connection
R1_m =L1_m/theta_trace_1;
X1_left = -2*R1_m*np.sin(1/2*theta_trace_1)+X1_right #calculate x coordinate on the left side of arc1
Y1_left =  Y1_right #calculate y coordinate on the left side of arc1
X1_C = X1_right - R1_m*np.sin(1/2*theta_trace_1) #calculate x coordinate on the center of arc1
Y1_C = Y1_left - R1_m*np.cos(1/2*theta_trace_1)  #calculate y coordinate on the center of arc1
X_in = X1_left - Width_T0/2+Width_T1/2   #calculate x coordinate on the center of input pad
# print(f"X1_left={X1_left:.4f} mil,Y1_left={Y1_left:.4f} mil" )
# print(f"X1_right={X1_right:.4f} mil,Y1_right={Y1_right:.4f} mil" )
# print(f"X1_C={X1_C:.4f} mil,Y1_C={Y1_C:.4f} mil" )
# print(f"Xin={X_in:.4f} mil" )
# print(f"incident angle = {theta_trace_1_degree:.5f} degree")
# %%trace2;
Width_T2 = 30.83;
L2 = 208.25;
theta_trace_2 =1*np.pi/3 # define the angle of arc2 
theta_trace_2_degree = theta_trace_2*180/np.pi
X2_left=Width_T1/2+Width_T2/2+d_gap+X1_right # calculate the x coordinate on the left side of arc2, with about 6 mil gap between the right edge of arc1 on the right side and the left edge of arc 2 on the left side
Width_T=Width_T2
X_left = X2_left
XL_R = xc_pad
L = L2
theta_trace = theta_trace_2
if Width_T<W_pad_x: 
    if Width_T<W_pad_y:         
        Y_right =  yc_pad+Width_T/2 # align the y coordinate on the right side of arc with the center of the pad
    else:
        Y_right =  yc_pad-W_pad_y/2+Width_T/2# align the y coordinate on the right side of arc1 with the end of the pad    
    L_m = L - 2 * Y_right - (X_left-XL_R) - (-Width_T / 2 + W_pad_x / 2)
    R_m = L_m/theta_trace
    X_right= X_left + 2*R_m*np.sin(1/2*theta_trace)
    XR_R = X_right-Width_T/2+W_pad_x/2
else:   
    R = Width_T/2
    l = W_pad_x/2
    d = R-np.sqrt(R**2-l**2)
    if d < W_pad_y/2:
        #Y_right =  yc_pad+W_pad_y/2-d+ Width_T/2 #align the end of the arc on the pad in vertical direction
         Y_right =  yc_pad-W_pad_y/2+ Width_T/2
    else: 
        Y_right =  yc_pad-W_pad_y/2+Width_T/2 #align the end of the arc on the bottom of the pad
    L_m = L - 2 * Y_right - (X_left-XL_R)
    R_m = L_m/theta_trace
    X_right= X_left + 2*R_m*np.sin(1/2*theta_trace)
    XR_R = X_right

Y2_right = Y_right
Y2_left = Y2_right

X2_right= X_right
X2_C= X2_left + R_m*np.sin(1/2*theta_trace_2)
Y2_C= Y2_left -R_m*np.cos(1/2*theta_trace_2)
X_2R = XR_R

print(f"X2_left={X2_left:.4f} mil,Y2_left={Y2_left:.4f} mil" )
print(f"X2_right={X2_right:.4f} mil,Y2_right={Y2_right:.4f} mil" )
print(f"X2_C={X2_C:.4f} mil,Y2_C={Y2_C:.4f} mil" )
print(f"incident angle = {theta_trace_2_degree:.5f} degree")
print(f"X_2R = {X_2R:.5f} mil")


# %%trace3;
Width_T3 = 28.05;
L3 = 400.46;
theta_trace_3 =3*np.pi/3
theta_trace_3_degree = theta_trace_3*180/np.pi
X3_left=Width_T2/2+Width_T3/2+d_gap+X2_right

Width_T=Width_T3
X_left = X3_left
XL_R = X_2R
L = L3
theta_trace = theta_trace_3
if Width_T<W_pad_x: 
    if Width_T<W_pad_y:         
        Y_right =  yc_pad+Width_T/2 # align the y coordinate on the right side of arc with the center of the pad
    else:
        Y_right =  yc_pad-W_pad_y/2+Width_T/2# align the y coordinate on the right side of arc1 with the end of the pad    
    L_m = L - 2 * Y_right - (X_left-XL_R) - (-Width_T / 2 + W_pad_x / 2)
    R_m = L_m/theta_trace
    X_right= X_left + 2*R_m*np.sin(1/2*theta_trace)
    XR_R = X_right-Width_T/2+W_pad_x/2
else:   
    R = Width_T/2
    l = W_pad_x/2
    d = R-np.sqrt(R**2-l**2)
    if d < W_pad_y:
        Y_right =  yc_pad+W_pad_y/2-d+ Width_T/2 #align the end of the arc on the pad in vertical direction
      
    else: 
        Y_right =  yc_pad-W_pad_y/2+Width_T/2 #align the end of the arc on the bottom of the pad
    L_m = L - 2 * Y_right - (X_left-XL_R)
    R_m = L_m/theta_trace
    X_right= X_left + 2*R_m*np.sin(1/2*theta_trace)
    XR_R = X_right

Y3_right = Y_right
Y3_left = Y3_right

X3_right= X_right
X3_C= X3_left + R_m*np.sin(1/2*theta_trace_3)
Y3_C= Y3_left -R_m*np.cos(1/2*theta_trace_3)
X_3R = XR_R

# print(f"X3_left={X3_left:.6f} mil,Y3_left={Y3_left:.6f} mil" )
# print(f"X3_right={X3_right:.6f} mil,Y3_right={Y3_right:.6f} mil" )
# print(f"X3_C={X3_C:.6f} mil,Y3_C={Y3_C:.6f} mil" )
# print(f"X_3R = {X_3R:.6f} mil")
# print(f"incident angle = {theta_trace_3_degree:.6f} degree")

# %% trace4;
Width_T4 = 38.65;
L4 = 395.82;
theta_trace_4 =2*np.pi/3
theta_trace_4_degree = theta_trace_4*180/np.pi
X4_left=Width_T3/2+Width_T4/2+d_gap+X3_right

Width_T=Width_T4
X_left = X4_left
XL_R = X_3R
L = L4
theta_trace = theta_trace_4
if Width_T<W_pad_x: 
    if Width_T<W_pad_y:         
        Y_right =  yc_pad+Width_T/2 # align the y coordinate on the right side of arc with the center of the pad
    else:
        Y_right =  yc_pad-W_pad_y/2+Width_T/2# align the y coordinate on the right side of arc1 with the end of the pad    
    L_m = L - 2 * Y_right - (X_left-XL_R) - (-Width_T / 2 + W_pad_x / 2)
    R_m = L_m/theta_trace
    X_right= X_left + 2*R_m*np.sin(1/2*theta_trace)
    XR_R = X_right-Width_T/2+W_pad_x/2
else:   
    R = Width_T/2
    l = W_pad_x/2
    d = R-np.sqrt(R**2-l**2)
    if d < W_pad_y:
        Y_right =  yc_pad+W_pad_y/2-d+ Width_T/2 #align the end of the arc on the center of the pad in vertical direction
    else: 
        Y_right =  yc_pad-W_pad_y/2+Width_T/2 #align the end of the arc on the bottom of the pad
    L_m = L - 2 * Y_right - (X_left-XL_R)
    R_m = L_m/theta_trace
    X_right= X_left + 2*R_m*np.sin(1/2*theta_trace)
    XR_R = X_right

Y4_right = Y_right
Y4_left = Y_right

X4_right= X_right
X4_C= X4_left + R_m*np.sin(1/2*theta_trace_4)
Y4_C= Y4_left -R_m*np.cos(1/2*theta_trace_4)
X_4R = XR_R

# print(f"X4_left={X4_left:.4f} mil,Y4_left={Y4_left:.4f} mil" )
# print(f"X4_right={X4_right:.4f} mil,Y4_right={Y4_right:.4f} mil" )
# print(f"X4_C={X4_C:.4f} mil,Y4_C={Y4_C:.4f} mil" )
# print(f"X_4R = {X_4R:.5f} mil")
# print(f"incident angle = {theta_trace_4_degree:.5f} degree")

