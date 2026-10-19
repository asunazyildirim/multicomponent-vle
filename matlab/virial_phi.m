function Phi = virial_phi(y, P_kPa, T_C, Psat, p, method)
%VIRIAL_PHI  The combined fugacity-coefficient factor Phi_i of the gamma-phi method.
%   Phi = VIRIAL_PHI(y, P, T_C, Psat, p, method); returns ones unless method = "GP".
%
%   Second virial coefficients from the Pitzer correlation with the
%   mixing rules w_ij = (w_i+w_j)/2, Tc_ij = sqrt(Tc_i Tc_j),
%   Zc_ij = (Zc_i+Zc_j)/2, Vc_ij = ((Vc_i^(1/3)+Vc_j^(1/3))/2)^3,
%   Pc_ij = Zc_ij R Tc_ij / Vc_ij.  Then (Smith, Van Ness & Abbott, Ch. 14):
%   Phi_i = exp{ [B_ii (P - Psat_i) + P/2 sum_j sum_k y_j y_k (2 d_ji - d_jk)] / RT },
%   d_ij = 2 B_ij - B_ii - B_jj.

if method ~= "GP"
    Phi = ones(size(y));
    return
end
T = T_C + 273.15;
Rb = 83.14;                                   % cm^3 bar/(mol K)

w   = (p.omega + p.omega') / 2;
Tcm = sqrt(p.Tc .* p.Tc');
Zcm = (p.Zc + p.Zc') / 2;
Vcm = ((p.Vc.^(1/3) + (p.Vc').^(1/3)) / 2).^3;
Pcm = Zcm .* Rb .* Tcm ./ Vcm;

Tr = T ./ Tcm;
B  = (0.083 - 0.422./Tr.^1.6 + w.*(0.139 - 0.172./Tr.^4.2)) .* Rb .* Tcm ./ Pcm * 1e-6;  % m^3/mol
d  = 2*B - diag(B) - diag(B)';

y = y(:);
mix = 2*sum(y)*(d' * y) - y' * d * y;         % sum_j sum_k y_j y_k (2 d_ji - d_jk)
R = 8.314e-3;                                 % kJ/(mol K); B*P in m^3/mol * kPa = kJ/mol
Phi = exp((diag(B) .* (P_kPa - Psat(:)) + 0.5*P_kPa*mix) / (R*T))';
end
