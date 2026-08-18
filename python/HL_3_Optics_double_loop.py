
from  numerical_optical_simulation import GaussianBeam,Thicklens,SpaceMatrix,OpticalMatrix,OpticalSystem
import numpy as np
import matplotlib.pyplot as plt
import math

# 1. 定义你要测试的三个 d_antenna_zoom1 的值
d_antenna_values = [0.140, 0.200, 0.300]  # 你可以自行修改这三个数值
first_lens = Thicklens(r1=1.55,r2=-1.55,d=0.260,n=1.623450)
s1 = np.linspace(0.01, 1.3, 100)
L_obj_1stlens = 4.590
L_fixed = 0.1 + 0.1
L_cutoff = 1.5671
lambda0 = 4 * 1e-3
w0 = 22 * 1e-3
hmax = 0.146
alpha_0 = 0
L0 =np.array([[hmax], [alpha_0]])
zoom1 = Thicklens(r1=1,r2=-1e99,d=0.1,n=1.623450)
zoom2 = Thicklens(r1=1,r2=-1e99,d=0.1,n=1.623450)

# 2. 外层循环：遍历不同的 d_antenna_zoom1
for d_antenna_zoom1 in d_antenna_values:

    space0 = SpaceMatrix(d_antenna_zoom1)

    # 每次更换 d_antenna_zoom1 时，清空/初始化存储列表
    f2h_list = []
    R_list = []
    z_new_list = []
    w0_new_list = []
    w_new_list = []
    z_R_list = []
    h_cutoff_list = []
    # 内层循环：计算随 s 变化的曲线
    for s in s1:
        space = SpaceMatrix(s)
        s2 = L_obj_1stlens - L_fixed - d_antenna_zoom1-s
        space2 = SpaceMatrix(s2)

        # 组合光学矩阵
        optics = OpticalMatrix(
            SpaceMatrix(0).Matrix
            @ first_lens.Matrix
            @ space2.Matrix
            @ zoom2.Matrix
            @ space.Matrix
            @ zoom1.Matrix
            @ space0.Matrix
        )

        f2h_list.append(optics.f_h2)
        L = optics.Matrix@L0
        h_cutoff = L[0,0]*1e3
        h_cutoff_list.append(h_cutoff)
        R_list.append(optics.f_h2)

        beam = GaussianBeam(w0=w0, lambda0=lambda0)
        system = OpticalSystem(beam, optics, z=0)

        # 提取新高斯光束参数
        z_new, w0_new, w_new = system.compute_new_waist()
        zR = np.pi * (w0_new * 1E-3) ** 2 / lambda0

        z_R_list.append(zR)
        z_new_list.append(z_new)
        w0_new_list.append(w0_new)
        w_new_list.append(w_new)

    # 3. 在对应的 Figure 上画出当前 d_antenna_zoom1 的曲线，并带上 label
    # 注意：这里去掉了每张图后面的 plt.show()，让它们在同一个窗口中叠加

    plt.figure(3)
    plt.plot(s1, R_list, label=f"d_antenna={d_antenna_zoom1}m")

    plt.figure(4)
    plt.plot(s1, z_R_list, label=f"d_antenna={d_antenna_zoom1}m")

    plt.figure(5)
    plt.plot(s1, z_new_list, label=f"d_antenna={d_antenna_zoom1}m")

    plt.figure(6)
    plt.plot(s1, w_new_list, label=f"d_antenna={d_antenna_zoom1}m")

    plt.figure(7)
    plt.plot(s1, w0_new_list, label=f"d_antenna={d_antenna_zoom1}m")

    plt.figure(8)
    plt.plot(s1, np.abs(h_cutoff_list), label=f"d_antenna={d_antenna_zoom1}m")
# 4. 所有数据计算并画完后，统一配置标签、图例并展示
plt.figure(3)
plt.xlabel("Distance from zoom1 to zoom2 (m)")
plt.ylabel("Matching radius at cutoff1 (m)")
plt.legend()
plt.grid(True)

plt.figure(4)
plt.xlabel("Distance from zoom1 to zoom2 (m)")
plt.ylabel("Rayleigh length (m)")
plt.legend()
plt.grid(True)

plt.figure(5)
plt.xlabel("Distance from zoom1 to zoom2 (m)")
plt.ylabel("Distance from waist to Cutoff1 (m)")
plt.legend()
plt.grid(True)

plt.figure(6)
plt.xlabel("Distance from zoom1 to zoom2 (m)")
plt.ylabel("Beam radius on first lens (m)")
plt.legend()
plt.grid(True)

plt.figure(7)
plt.xlabel("Distance from zoom1 to zoom2 (m)")
plt.ylabel("waist radius (m)")
plt.legend()
plt.grid(True)

plt.figure(8)
plt.xlabel("Distance from zoom1 to zoom2 (m)")
plt.ylabel("h_max on cutoff1 (mm)")
plt.legend()
plt.grid(True)
# 最后统一弹窗显示所有图表
plt.show()
