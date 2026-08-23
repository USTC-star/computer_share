import pandas as pd
from  numerical_optical_simulation import GaussianBeam,Thicklens,SpaceMatrix,OpticalMatrix,OpticalSystem
import numpy as np
import matplotlib.pyplot as plt
import math
# 在最外层定义一个列表，用于收集所有行数据
all_rows = []
d_antenna_values = [0.140, 0.200, 0.300]  # 你可以自行修改这三个数值
first_lens = Thicklens(r1=1.55,r2=-1.55,d=0.260,n=1.623450)
s1 = np.linspace(0.01, 1.3, 100)
L_obj_1stlens = 4.590
L_fixed = 0.1 + 0.1
L_cutoff = 1.5429
lambda0 = 4 * 1e-3
w0 = 22 * 1e-3
zoom1 = Thicklens(r1=1,r2=-1e99,d=0.1,n=1.623450)
zoom2 = Thicklens(r1=1,r2=-1e99,d=0.1,n=1.623450)
for d_antenna_zoom1 in d_antenna_values:
    space0 = SpaceMatrix(d_antenna_zoom1)

    # 每次更换 d_antenna_zoom1 时，清空/初始化存储列表
    f2h_list = []
    R_list = []
    z_new_list = []
    w0_new_list = []
    w_new_list = []
    z_R_list = []

    for s in s1:
        space = SpaceMatrix(s)
        s2 = L_obj_1stlens - L_fixed - d_antenna_zoom1 - s
        space2 = SpaceMatrix(s2)

        # 组合光学矩阵
        optics = OpticalMatrix(
            SpaceMatrix(L_cutoff).Matrix
            @ first_lens.Matrix
            @ space2.Matrix
            @ zoom2.Matrix
            @ space.Matrix
            @ zoom1.Matrix
            @ space0.Matrix
        )

        f2h_list.append(optics.f_h2)
        R_list.append(optics.f_h2)

        beam = GaussianBeam(w0=w0, lambda0=lambda0)
        system = OpticalSystem(beam, optics, z=0)

        # 提取新高斯光束参数
        z_new, w0_new, w_new = system.compute_new_waist()
        zR = np.pi * (w0_new * 1E-3) ** 2 / lambda0

        z_new, w0_new, w_new = system.compute_new_waist()
        zR = np.pi * (w0_new * 1E-3) ** 2 / lambda0

        # 核心：将每一次迭代的所有参数打包成一个字典，追加到列表中
        all_rows.append({
            "d_antenna_zoom1": d_antenna_zoom1,
            "s1_spacing": s,
            "R": optics.f_h2,
            "z_R": zR,
            "z_new": z_new,
            "w_new": w_new,
            "w0_new": w0_new
        })

# 循环结束后，一键转化为 Pandas DataFrame
df = pd.DataFrame(all_rows)

# 1. 保持在内存中：现在你可以随时通过 df 访问任何数据，例如：
# print(df[df['d_antenna_zoom1'] == 0.140])

# 2. 导出为外部文件（持久化保持）
df.to_csv("gaussian_beam_results.csv", index=False, encoding="utf-8-sig")
print("所有计算数据已成功保存至 gaussian_beam_results.csv 文件中！")
