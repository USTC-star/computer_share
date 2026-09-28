"""
Core functions for the autoresonant capture equation:
    i dPsi/dT + (|Psi|^2 - T) Psi = mu
No script-level execution here -- safe to import repeatedly / in loops.
"""
import numpy as np
from scipy.integrate import solve_ivp


def rhs(T, y, mu):
    Psi = y[0] + 1j * y[1]
    dPsi = 1j * (abs(Psi) ** 2 - T) * Psi - 1j * mu
    return [dPsi.real, dPsi.imag]


def integrate(mu, T0=-15.0, T_end=15.0, Psi0=0.0 + 0.0j, n_eval=600,
              rtol=1e-7, atol=1e-9, max_step=0.05):
    y0 = [Psi0.real, Psi0.imag]
    sol = solve_ivp(
        rhs, [T0, T_end], y0, args=(mu,),
        t_eval=np.linspace(T0, T_end, n_eval),
        rtol=rtol, atol=atol, method="RK45", max_step=max_step,
    )
    Psi = sol.y[0] + 1j * sol.y[1]
    return sol.t, Psi


def is_captured(T, Psi, T_check=10.0):
    amp2 = np.abs(Psi) ** 2
    mask = T >= T_check
    if not np.any(mask):
        return False
    diff = amp2[mask] - T[mask]
    return np.mean(np.abs(diff)) < 0.5 * np.mean(T[mask])
