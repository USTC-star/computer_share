import numpy as np

class GaussianBeam:
    def __init__(self, w0, lambda0):
        self.w0 = w0
        self.lambda0 = lambda0
        self.zR = np.pi * w0**2 / lambda0

    def q_at_distance(self, z):
        """Return q parameter at distance z from waist"""
        return z + 1j * self.zR


class ThinLens:
    def __init__(self,r1,r2,n):
        inv_f = 1/r1*(n-1)-1/r2*(n-1)
        self.f = 1/inv_f

    def transform(self, q_in):
        """Apply lens transformation"""
        return q_in / (1 - q_in / self.f)


class OpticalSystem:
    def __init__(self, beam, lens, z):
        self.beam = beam
        self.lens = lens
        self.z = z   # waist → lens distance

    def compute_new_waist(self):
        # q at lens
        q_in = self.beam.q_at_distance(self.z)

        # through lens
        q_out = self.lens.transform(q_in)

        # extract waist
        z_new = -np.real(q_out)
        zR_new = np.imag(q_out)
        w0_new = np.sqrt(self.beam.lambda0 * zR_new / np.pi)

        return z_new, w0_new
    
class Thicklens:
    def __init__(self,r1,r2,d,n):
        P12 = -1/r1*(n-1)*1/n
        P23 = 1/r2*(n-1)
        P = (P12*n+P23+d*P12*P23)
        self.f = -1/P
        self.H1 = -P12/P*d
        self.H2 = -P23/P/n*d
        self.Matrix = np.array([[1,0],[-1/self.f,1]])

def main():
# ---------- Example ----------
    beam = GaussianBeam(w0=1e-3, lambda0=10.6e-6)
    lens = ThinLens(r1=0.6, r2=-0.6, n=1.6)
    lens2 = Thicklens(r1=0.6, r2=-0.6, d=0.2, n=1.6)
    system = OpticalSystem(beam, lens, z=0.2)
    z_new, w0_new = system.compute_new_waist()
    
    print("New waist position:", z_new)
    print("New waist size:", w0_new)
    print("thicklens foucs length f = :%.2f m" % lens2.f)
    print("thinlens foucs length f =  m" , lens2.Matrix)
if __name__ == "__main__":
        main()