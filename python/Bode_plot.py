# -*- coding: utf-8 -*-
"""
Created on Sun Apr  5 23:27:02 2026

@author: PinJung
"""

import numpy as np
import matplotlib.pyplot as plt

# 1. 参数设置
R1, R2, C = 10000, 500, 1e-7
w1 = 1 / (C * (R1 + R2))
w2 = 1 / (C * R2)

# 2. 生成数据
w = np.logspace(np.log10(w1/10), np.log10(w2*10), 1000)
F_s = (1 + 1j*w/w2) / (1 + 1j*w/w1)
mag_db = 20 * np.log10(np.abs(F_s))

# 重要：确保这些值是纯数值（标量）
high_freq_gain = float(20 * np.log10(R2 / (R1 + R2)))
w1_val = float(w1)
w2_val = float(w2)

# single pole loss pass filter
F_s_2 = 1 / (1 + 1j*w/w1)
mag_db_2 = 20 * np.log10(np.abs(F_s_2))
# 3. 绘图
plt.figure(figsize=(10, 6))
plt.semilogx(w, mag_db, color='blue', linewidth=2.5, label='Actual Response')
plt.semilogx(w, mag_db_2, color='blue', linewidth=2.5, label='Single Pole Response')

# 绘制渐近线 (理想化的折线)
low_freq = [w[1], w1, w2, w[-1]]
high_gain = 20 * np.log10(R2 / (R1 + R2))
asymptote = [0, 0, high_gain, high_gain]
plt.semilogx(low_freq, asymptote, '--', label='Asymptotic Approximation', color='red')
# --- 标注部分 (修正后的写法) ---

# 标注极点 w1 - 使用 float 确保传给 text 的是标量
plt.axvline(w1_val, color='red', linestyle='--', alpha=0.6)
plt.text(w1_val, -2, f' Pole $\omega_1$\n ({w1_val:.1f})', 
         color='red', fontweight='bold', ha='center')

# 标注零点 w2
plt.axvline(w2_val, color='green', linestyle='--', alpha=0.6)
plt.text(w2_val, high_freq_gain + 1, f' Zero $\omega_2$\n ({w2_val:.1f})', 
         color='green', fontweight='bold', ha='center')

# 标注高频增益
plt.axhline(high_freq_gain, color='gray', linestyle=':', alpha=0.5)

# 图表修饰
plt.title('Bode Magnitude Plot', fontsize=14)
plt.xlabel('Frequency $\omega$ (rad/s)')
plt.ylabel('Magnitude (dB)')
plt.grid(True, which="both", ls="-", alpha=0.3)
plt.legend()

plt.show()


# 创建 2 行 1 列的子图
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8), sharex=True)
phase = np.angle(F_s, deg=True)
# 绘制幅频图 (上方)
ax1.semilogx(w, mag_db, color='blue')
ax1.set_ylabel('Magnitude (dB)')
ax1.grid(True, which="both")
ax1.set_title('Bode Plot')

# 绘制相频图 (下方)
ax2.semilogx(w, phase, color='orange')
ax2.set_ylabel('Phase (deg)')
ax2.set_xlabel('Frequency (rad/s)')
ax2.grid(True, which="both")

plt.tight_layout() # 自动调整间距，防止标签重叠
plt.show()