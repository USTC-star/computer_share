"""
Autoresonant capture simulation for:

    i dPsi/dT + (|Psi|^2 - T) Psi = mu

Rearranged for integration:
    dPsi/dT = i*(|Psi|^2 - T)*Psi - i*mu

We integrate from a very negative T0 (well before the resonance at T=0)
up to a large positive T_end, and classify the outcome as:

  - CAPTURED   : |Psi|^2 tracks T (stays on the growing nonlinear-resonance
                 branch, |Psi|^2 - T stays small/bounded)
  - NOT CAPTURED: |Psi|^2 stays small / oscillatory and does NOT grow with T

Two experiments:
  1. Capture diagram vs mu (single initial condition Psi(T0)=0)
  2. Robustness test: fix mu slightly above threshold (mu=0.5) and scan a
     grid of initial amplitudes / phases at T0, to see that capture happens
     almost independently of initial condition (as long as T0 is early enough)
"""

import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# ----------------------------------------------------------------------
# Core RHS
# ----------------------------------------------------------------------
def rhs(T, y, mu):
    # y = [Re(Psi), Im(Psi)]
    Psi = y[0] + 1j * y[1]
    dPsi = 1j * (abs(Psi) ** 2 - T) * Psi - 1j * mu
    return [dPsi.real, dPsi.imag]


def integrate(mu, T0=-15.0, T_end=15.0, Psi0=0.0 + 0.0j, n_eval=3000):
    y0 = [Psi0.real, Psi0.imag]
    sol = solve_ivp(
        rhs, [T0, T_end], y0, args=(mu,),
        t_eval=np.linspace(T0, T_end, n_eval),
        rtol=1e-9, atol=1e-11, method="RK45", max_step=0.02,
    )
    Psi = sol.y[0] + 1j * sol.y[1]
    return sol.t, Psi


def is_captured(T, Psi, T_check=10.0):
    """
    Capture test: near the end of the sweep, the captured branch has
    |Psi|^2 approx T (the resonant nonlinear branch grows with T).
    An uncaptured solution stays bounded / does not track T.
    """
    amp2 = np.abs(Psi) ** 2
    mask = T >= T_check
    if not np.any(mask):
        return False
    # captured if |Psi|^2 tracks T within a modest tolerance over the tail
    diff = amp2[mask] - T[mask]
    return np.mean(np.abs(diff)) < 0.5 * np.mean(T[mask])


# ----------------------------------------------------------------------
# Experiment 1: capture diagram vs mu
# ----------------------------------------------------------------------
mus = np.linspace(0.1, 0.7, 61)
captured_flags = []

for mu in mus:
    T, Psi = integrate(mu, Psi0=0.0 + 0.0j)
    captured_flags.append(is_captured(T, Psi))

captured_flags = np.array(captured_flags)

# find the numerical threshold: first mu (scanning downward) where capture fails
capture_idx = np.where(captured_flags)[0]
threshold_est = mus[capture_idx[0]] if len(capture_idx) else None

fig1, axes1 = plt.subplots(1, 2, figsize=(11, 4.2))

ax = axes1[0]
ax.plot(mus, captured_flags.astype(int), "o-", color="tab:blue", ms=4)
ax.axvline(0.41, color="tab:red", ls="--", label=r"predicted $\mu_c\approx0.41$")
if threshold_est is not None:
    ax.axvline(threshold_est, color="tab:green", ls=":", label=f"numerical onset $\\approx${threshold_est:.3f}")
ax.set_xlabel(r"$\mu$")
ax.set_ylabel("captured (1) / not captured (0)")
ax.set_title("Capture outcome vs drive amplitude $\\mu$")
ax.set_yticks([0, 1])
ax.legend(fontsize=8)

ax = axes1[1]
for mu, style in [(0.30, "tab:red"), (0.41, "0.4"), (0.55, "tab:green")]:
    T, Psi = integrate(mu, Psi0=0.0 + 0.0j)
    ax.plot(T, np.abs(Psi) ** 2, label=f"$\\mu={mu}$", color=style)
ax.plot(T, np.clip(T, 0, None), "k--", lw=1, label="$|\\Psi|^2=T$ (resonant branch)")
ax.set_xlabel("$T$")
ax.set_ylabel(r"$|\Psi|^2$")
ax.set_title("Trajectories: captured vs not captured")
ax.legend(fontsize=8)
ax.set_xlim(-15, 15)

fig1.tight_layout()
# fig1.savefig("/mnt/user-data/outputs/capture_vs_mu.png", dpi=150)

# ----------------------------------------------------------------------
# Experiment 2: robustness to initial conditions at fixed mu
# ----------------------------------------------------------------------
mu_fixed = 0.9
T0 = -15.0

amps = np.linspace(2, 3, 53)      # initial |Psi(T0)|
phases = np.linspace(0.0, 1, 33, endpoint=False)  # initial phase

grid_result = np.zeros((len(amps), len(phases)))

for i, a in enumerate(amps):
    for j, ph in enumerate(phases):
        Psi0 = a * np.exp(1j * ph)
        T, Psi = integrate(mu_fixed, T0=T0, Psi0=Psi0)
        grid_result[i, j] = 1.0 if is_captured(T, Psi) else 0.0

fig2, ax2 = plt.subplots(figsize=(5.5, 4.5))
im = ax2.pcolormesh(phases, amps, grid_result, shading="auto", cmap="RdYlGn", vmin=0, vmax=1)
ax2.set_xlabel("initial phase (rad)")
ax2.set_ylabel(r"initial $|\Psi(T_0)|$")
ax2.set_title(f"Capture map at $\\mu={mu_fixed}$, $T_0={T0}$\n(green = captured, red = not captured)")
fig2.colorbar(im, ax=ax2, label="captured")
fig2.tight_layout()
# fig2.savefig("/mnt/user-data/outputs/capture_vs_initial_conditions.png", dpi=150)

frac_captured = grid_result.mean()

print(f"Numerical onset of capture (mu scan, Psi0=0): mu ~ {threshold_est}")
print(f"Fraction of (amplitude, phase) grid captured at mu={mu_fixed}: {frac_captured:.3f}")
