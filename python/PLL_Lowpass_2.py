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
f_in = np.ones(N) * 900
f_in[N//4:] = 1300 
f_in[N//3:] = 800 
f_in[N//2:] = 900 
phase_in = 2 * np.pi * np.cumsum(f_in) / fs
sig_in = np.sin(phase_in)

# 2. 环路滤波器参数 (基于你之前的电路)
# F(s) = (1 + s/w2) / (1 + s/w1) -> 离散化处理
R1, R2, C = 20000, 20000,7e-6
w1 = 1 / (C * (R1 + R2))
w2 = 1 / (C * R2)

# 离散化滤波器系数 (使用双线性变换或简单的差分方程)
# 这里简化为直接在时域模拟：v_out + tau1*dv_out/dt = v_in + tau2*dv_in/dt
tau1, tau2 = 1/w1, 1/w2

# 3. PLL 初始化
vco_phase = 0
vco_freq_center = 1000  # VCO 中心频率
vco_gain = 1000          # VCO 灵敏度 (Hz/V)
lp_out = 0              # 滤波器输出控制电压
prev_mixer_out = 0
prev_lp_out = 0
KO=2
# 存储结果
sig_vco = np.zeros(N)
v_control = np.zeros(N)
freq_vco = np.zeros(N)

# --- 在参数设置区新增 ---
R3 = 30000     # 2k Ohm
C3 = 2e-8     # 0.1 uF
tau3 = R3 * C3 # 第三个极点的时间常数

# --- 在初始化区新增 ---
lp_final = 0   # 经过第二级滤波后的最终控制电压
prev_lp_final = 0
dt = 1/fs
# --- 在闭环迭代循环内 (Step B 之后) 修改 ---
for i in range(1, N):
    # (之前的 Mixer 和 第一级滤波器计算 lp_out ...)
    mixer_out = sig_in[i] * np.cos(vco_phase) * KO
    lp_out = (prev_lp_out * (tau1 - dt) + mixer_out * dt + tau2 * (mixer_out - prev_mixer_out)) / tau1
    # lp_out = mixer_out
    # === 新增：第二级 RC 低通滤波 (方案一) ===
    # 公式：lp_final + tau3 * d(lp_final)/dt = lp_out
    lp_final = (prev_lp_final * tau3 + lp_out * dt) / (tau3 + dt)
     # lp_final =  lp_out
    # 更新历史状态
    prev_mixer_out = mixer_out
    prev_lp_out = lp_out
    prev_lp_final = lp_final # 更新第二级状态
    
    # === 修改：使用过滤后的 lp_final 更新 VCO ===
    current_freq = vco_freq_center + vco_gain * lp_final
    vco_phase += 2 * np.pi * current_freq * dt
    
    # 记录数据时改记录 lp_final
    v_control[i] = lp_final
    freq_vco[i] = current_freq

# 5. 绘图
# 绘图前对 v_control 进行简单的平滑处理 (比如 100 点平均)
window_size = 500
v_smooth = np.convolve(v_control, np.ones(window_size)/window_size, mode='same')
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8))



# --- Top plot: Frequency tracking ---
ax1.plot(t, f_in, 'r', label='Input Freq')
ax1.plot(t, freq_vco, 'b', label='VCO Freq')
ax1.set_title('Frequency Tracking')
ax1.legend()
ax1.grid(True)
ax1.set_xlim(0.0, 0.28)
# --- Bottom plot: Control voltage ---
ax2.plot(t, v_control, 'g')
# ax2.plot(t, v_smooth, 'g')  # optional
ax2.set_title('Control Voltage (Filter Output)')
ax2.set_xlabel('Time (s)')
ax2.grid(True)

# --- Set x-axis limit ONCE (shared) ---
ax2.set_xlim(0.0, 0.28)

# --- Layout ---
plt.tight_layout()
plt.show()