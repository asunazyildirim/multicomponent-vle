function [T_C, x, info] = dew_T(y, P, p, method)
%DEW_T  Dew-point temperature (degC) and liquid composition at P (kPa).
%   [T_C, x, info] = DEW_T(y, P, p, method), method = "RL" | "MRL" | "GP".
%
%   Smith, Van Ness & Abbott DEW T algorithm: pick component j (here 1),
%   Psat_j = P sum_i (y_i Phi_i / gamma_i)(Psat_j / Psat_i),
%   T = Tsat_j(Psat_j); inner loop on gamma(x), outer loop on T.

j     = 1;
Phi   = ones(size(y));
gamma = ones(size(y));
T_C   = sum(y .* tsat(p, P));                 % initial guess

converged = false;
for iter = 1:500
    Psat   = psat(p, T_C);
    Phi    = virial_phi(y, P, T_C, Psat, p, method);
    gamma  = converge_gamma(y, Phi, P, Psat, gamma, T_C, p, method);
    Psat_j = P * sum(y .* Phi ./ gamma .* Psat(j) ./ Psat);
    T_new  = tsat(p, Psat_j, j);
    if abs(T_new - T_C) < 1e-8
        T_C = T_new;
        converged = true;
        break
    end
    T_C = T_new;
end
if ~converged
    error('vle:noconvergence', 'dew_T did not converge.');
end
Psat = psat(p, T_C);
x    = y .* Phi * P ./ (gamma .* Psat);
info = struct('gamma', gamma, 'Phi', Phi, 'iterations', iter);
end
