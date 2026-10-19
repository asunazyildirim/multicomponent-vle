function [P, x, info] = dew_P(y, T_C, p, method)
%DEW_P  Dew-point pressure (kPa) and liquid composition at T_C (degC).
%   [P, x, info] = DEW_P(y, T_C, p, method), method = "RL" | "MRL" | "GP".
%
%   x_i = y_i Phi_i P / (gamma_i Psat_i),  P = 1 / sum(y_i Phi_i / (gamma_i Psat_i))
%   gamma depends on the unknown x: inner loop on gamma (normalized x),
%   outer loop on P (and Phi).

Psat  = psat(p, T_C);
gamma = ones(size(y));
Phi   = ones(size(y));
P     = 1 / sum(y .* Phi ./ (gamma .* Psat));
x     = y .* Phi * P ./ (gamma .* Psat);
gamma = wilson_gamma(x, T_C, p, method);
P     = 1 / sum(y .* Phi ./ (gamma .* Psat));

converged = false;
for iter = 1:200
    Phi   = virial_phi(y, P, T_C, Psat, p, method);
    gamma = converge_gamma(y, Phi, P, Psat, gamma, T_C, p, method);
    P_new = 1 / sum(y .* Phi ./ (gamma .* Psat));
    if abs(P_new - P) < 1e-8 * P_new
        P = P_new;
        converged = true;
        break
    end
    P = P_new;
end
if ~converged
    error('vle:noconvergence', 'dew_P did not converge.');
end
x = y .* Phi * P ./ (gamma .* Psat);
info = struct('gamma', gamma, 'Phi', Phi, 'iterations', iter);
end
