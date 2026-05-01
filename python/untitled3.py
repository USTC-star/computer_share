# -*- coding: utf-8 -*-
"""
Created on Tue Apr 28 01:19:50 2026

@author: PinJung
"""

import numpy as np
import matplotlib.pyplot as plt
def normalize(v):
    return v / np.linalg.norm(v)

def intersect_sphere(ray_origin, ray_dir, R, z_center):
    # sphere center
    C = np.array([0, z_center])
    
    oc = ray_origin - C
    
    a = np.dot(ray_dir, ray_dir)
    b = 2 * np.dot(oc, ray_dir)
    c = np.dot(oc, oc) - R**2
    
    disc = b**2 - 4*a*c
    if disc < 0:
        return None
    
    t = (-b - np.sqrt(disc)) / (2*a)
    point = ray_origin + t * ray_dir
    return point

def refract(ray_dir, normal, n1, n2):
    ray_dir = normalize(ray_dir)
    normal = normalize(normal)
    
    cos_i = -np.dot(normal, ray_dir)
    sin2_t = (n1/n2)**2 * (1 - cos_i**2)
    
    if sin2_t > 1:
        return None  # total internal reflection
    
    cos_t = np.sqrt(1 - sin2_t)
    
    return (n1/n2)*ray_dir + ( (n1/n2)*cos_i - cos_t )*normal

def trace_lens(ray_origin, ray_dir, R1, R2, thickness, n):
    # first surface
    p1 = intersect_sphere(ray_origin, ray_dir, R1, R1)
    if p1 is None:
        return None
    
    normal1 = normalize(p1 - np.array([0, R1]))
    d1 = refract(ray_dir, normal1, 1.0, n)
    
    # second surface
    p2 = intersect_sphere(p1, d1, R2, thickness + R2)
    if p2 is None:
        return None
    
    normal2 = normalize(p2 - np.array([0, thickness + R2]))
    d2 = refract(d1, normal2, n, 1.0)
    
    return p2, d2

def propagate_to_plane(point, direction, z_plane):
    t = (z_plane - point[1]) / direction[1]
    return point + t * direction



R1 = 0.05
R2 = -0.05
thickness = 0.01
n = 1.5

y_obj_list = np.linspace(0, 2e-2, 18)
z_scan = np.linspace(0.05, 0.2, 100)

focus_positions_z = []
focus_positions_y = []

for y0 in y_obj_list:
    min_spot = 1e9
    best_z = None
    
    for z in z_scan:
        rays_z = []
        rays_y = []
        
        for angle in [-0.05, 0, 0.05]:
            origin = np.array([y0, 0])
            direction = normalize(np.array([angle, 1]))
            
            result = trace_lens(origin, direction, R1, R2, thickness, n)
            if result is None:
                continue
            
            p2, d2 = result
            img_point = propagate_to_plane(p2, d2, z)
            rays_z.append(img_point[1])
            rays_y.append(img_point[0])
        
        if len(rays_z) < 2:
            continue
        
        spot = np.std(rays_y)
        
        if spot < min_spot:
            min_spot = spot
            best_z = np.mean(rays_z)
            best_yout = np.mean(rays_y)
    
    focus_positions_z.append(best_z)
    focus_positions_y.append(best_yout)


print("Focus vs field:", focus_positions_z)
plt.plot(focus_positions_z,focus_positions_y,'.')