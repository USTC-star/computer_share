# -*- coding: utf-8 -*-
"""
Created on Mon Apr  6 00:17:16 2026

@author: PinJung
"""

import numpy as np
import matplotlib.pyplot as plt

# 1. 系统参数设置
fs = 1e6          # 采样率 100kHz
T = 0.3              # 模拟时长 0.1秒
t = np.arange(0, T, 1/fs)
N = len(t)

# 输入信号：1kHz 正弦波，在 0.05s 时发生频率跳变到 1.1kHz
f_in = np.ones(N) * 1000
f_in[N//4:] = 1300 
f_in[N//2:] = 700 
phase_in = 2 * np.pi * np.cumsum(f_in) / fs
sig_in = np.sin(phase_in)

# 2. 环路滤波器参数 (基于你之前的电路)
# F(s) = (1 + s/w2) / (1 + s/w1) -> 离散化处理
R1,R2,C = 5000,1E-19,9e-7
w1 = 1 / (C * (R1 + R2))
w2 = 1 / (C * R2)

# 离散化滤波器系数 (使用双线性变换或简单的差分方程)
# 这里简化为直接在时域模拟：v_out + tau1*dv_out/dt = v_in + tau2*dv_in/dt
tau1, tau2 = 1/w1, 1/w2

# 3. PLL 初始化
vco_phase = 0
vco_freq_center = 1000  # VCO 中心频率
vco_gain = 2000          # VCO 灵敏度 (Hz/V)
lp_out = 0              # 滤波器输出控制电压
prev_mixer_out = 0
prev_lp_out = 0
KO=3
# 存储结果
sig_vco = np.zeros(N)
v_control = np.zeros(N)
freq_vco = np.zeros(N)

# 4. 闭环迭代模拟
for i in range(1, N):
    # A. 鉴相器 (Mixer): 输入信号与 VCO 输出相乘
    # 假设 VCO 输出为余弦波，这样混频后低频项为 sin(delta_phi)
    mixer_out = sig_in[i] * np.cos(vco_phase)*KO
    
    # B. 环路滤波器 (差分方程模拟单极点单零点)
    # 使用欧拉近似：dy/dt ≈ (y[n] - y[n-1]) / dt
    dt = 1/fs
    lp_out = (prev_lp_out * (tau1 - dt) + mixer_out * dt + tau2 * (mixer_out - prev_mixer_out)) / tau1
    
    # 更新历史状态
    prev_mixer_out = mixer_out
    prev_lp_out = lp_out
    
    # C. VCO 更新
    current_freq = vco_freq_center + vco_gain * lp_out
    vco_phase += 2 * np.pi * current_freq * dt
    
    # 记录数据
    sig_vco[i] = np.cos(vco_phase)
    v_control[i] = lp_out
    freq_vco[i] = current_freq

# 5. 绘图
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8))

ax1.plot(t, f_in, 'r', label='Input Freq')
ax1.plot(t, freq_vco, 'b', label='VCO Freq')
ax1.set_title('Frequency Tracking')
ax1.legend()
ax1.grid(True)

ax2.plot(t, v_control, 'g')
ax2.set_title('Control Voltage (Filter Output)')
ax2.set_xlabel('Time (s)')
ax2.grid(True)

plt.tight_layout()
plt.show()