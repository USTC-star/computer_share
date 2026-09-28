"""
Parallel version of the (initial amplitude, initial phase) capture-map scan
for:  i dPsi/dT + (|Psi|^2 - T) Psi = mu

Each grid point is an independent ODE integration -> embarrassingly
parallel. We use concurrent.futures.ProcessPoolExecutor to spread the
N*N integrations across all available CPU cores, and report progress
as tasks complete (works with tqdm if installed, otherwise a plain
percentage printout with no extra dependency).

NOTE: this only speeds things up on a machine with >1 CPU core. Check
with `os.cpu_count()` -- on a single-core machine (e.g. this sandbox)
a process pool adds overhead instead of helping.
"""
import os
import time
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap, BoundaryNorm
from concurrent.futures import ProcessPoolExecutor, as_completed
from capture_core import integrate, is_captured

try:
    from tqdm import tqdm
    HAVE_TQDM = True
except ImportError:
    HAVE_TQDM = False

MU = 0.9
T0 = -15.0
SOLVER_KW = dict(rtol=1e-8, atol=1e-10, max_step=0.05, n_eval=1500)


# --- progress helper: uses tqdm if available, otherwise prints a plain
#     "done/total (pct%)" line in place -----------------------------------
class Progress:
    def __init__(self, total, desc=""):
        self.total = total
        self.desc = desc
        self.count = 0
        self.t0 = time.time()
        if HAVE_TQDM:
            self.bar = tqdm(total=total, desc=desc)
        else:
            self.bar = None
            print(f"{desc}: 0/{total} (0.0%)", end="", flush=True)

    def update(self, n=1):
        self.count += n
        if HAVE_TQDM:
            self.bar.update(n)
        else:
            pct = 100.0 * self.count / self.total
            elapsed = time.time() - self.t0
            eta = elapsed / self.count * (self.total - self.count) if self.count else 0.0
            print(
                f"\r{self.desc}: {self.count}/{self.total} "
                f"({pct:5.1f}%)  elapsed={elapsed:6.1f}s  eta={eta:6.1f}s   ",
                end="", flush=True,
            )

    def close(self):
        if HAVE_TQDM:
            self.bar.close()
        else:
            print()  # newline after the in-place progress line


# --- worker: must be a top-level function so it can be pickled and sent
#     to worker processes -------------------------------------------------
def _evaluate_point(args):
    i, j, amp, phase = args
    Psi0 = amp * np.exp(1j * phase)
    T, Psi = integrate(MU, T0=T0, Psi0=Psi0, **SOLVER_KW)
    return i, j, is_captured(T, Psi)


def compute_grid_parallel(N, n_workers=None, chunksize=4, show_progress=True):
    """
    Compute the NxN (amplitude, phase) capture grid, splitting the N*N
    independent integrations across n_workers processes. Reports progress
    as results come back (not necessarily in submission order).
    """
    n_workers = n_workers or os.cpu_count() or 1
    amps = np.linspace(0.0, 3.0, N)
    phases = np.linspace(0.0, 2 * np.pi, N, endpoint=False)

    tasks = [
        (i, j, a, ph)
        for i, a in enumerate(amps)
        for j, ph in enumerate(phases)
    ]

    grid = np.zeros((N, N))
    progress = Progress(len(tasks), desc=f"parallel N={N}") if show_progress else None

    with ProcessPoolExecutor(max_workers=n_workers) as pool:
        futures = [pool.submit(_evaluate_point, t) for t in tasks]
        for fut in as_completed(futures):
            i, j, captured = fut.result()
            grid[i, j] = captured
            if progress:
                progress.update(1)

    if progress:
        progress.close()

    return amps, phases, grid


def compute_grid_serial(N, show_progress=True):
    """Reference serial version (same math, no process pool) for comparison."""
    amps = np.linspace(0.0, 3.0, N)
    phases = np.linspace(0.0, 2 * np.pi, N, endpoint=False)
    grid = np.zeros((N, N))

    progress = Progress(N * N, desc=f"serial   N={N}") if show_progress else None
    for i, a in enumerate(amps):
        for j, ph in enumerate(phases):
            Psi0 = a * np.exp(1j * ph)
            T, Psi = integrate(MU, T0=T0, Psi0=Psi0, **SOLVER_KW)
            grid[i, j] = is_captured(T, Psi)
            if progress:
                progress.update(1)
    if progress:
        progress.close()

    return amps, phases, grid


if __name__ == "__main__":
    N = 200
    n_workers = os.cpu_count() or 1
    print(f"detected CPU cores: {n_workers}  (tqdm available: {HAVE_TQDM})")

    # t0 = time.time()
    # amps, phases, grid_serial = compute_grid_serial(N)
    # t_serial = time.time() - t0
    # print(f"serial:   {t_serial:6.1f} s  (N={N})")

    t0 = time.time()
    amps, phases, grid_parallel = compute_grid_parallel(N, n_workers=n_workers)
    t_parallel = time.time() - t0
    # print(f"parallel: {t_parallel:6.1f} s  (N={N}, {n_workers} workers, "
    #       f"speedup x{t_serial / t_parallel:.2f})")

    # assert np.array_equal(grid_serial, grid_parallel), "serial/parallel results differ!"
    # print("serial and parallel results match exactly.")

    cmap2 = ListedColormap(["tab:red", "tab:blue"])
    norm2 = BoundaryNorm([-0.5, 0.5, 1.5], cmap2.N)
    fig, ax = plt.subplots(figsize=(6.3, 4.5))
    im = ax.pcolormesh(phases, amps, grid_parallel, shading="auto", cmap=cmap2, norm=norm2)
    ax.set_xlabel("initial phase (rad)")
    ax.set_ylabel(r"initial $|\Psi(T_0)|$")
    ax.set_title(f"Capture map (parallel), mu={MU}, N={N}")
    cbar = fig.colorbar(im, ax=ax, ticks=[0, 1])
    cbar.ax.set_yticklabels(["not captured", "captured"])
    fig.tight_layout()
    # fig.savefig("/mnt/user-data/outputs/capture_parallel_result.png", dpi=150)
