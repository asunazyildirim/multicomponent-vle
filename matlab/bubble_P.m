function [P, y, info] = bubble_P(x, T_C, p, method)
%BUBBLE_P  Bubble-point pressure (kPa) and vapour composition at T_C (degC).
%   [P, y, info] = BUBBLE_P(x, T_C, p, method), method = "RL" | "MRL" | "GP".
%
%   gamma-phi:  y_i Phi_i P = x_i gamma_i Psat_i
%   gamma depends only on x and T, so it is fixed; iterate on Phi(y, P).

Psat  = psat(p, T_C);
gamma = wilson_gamma(x, T_C, p, method);
Phi   = ones(size(x));
P     = sum(x .* gamma .* Psat ./ Phi);

converged = false;
for iter = 1:200
    y     = x .* gamma .* Psat ./ (Phi * P);
    Phi   = virial_phi(y, P, T_C, Psat, p, method);
    P_new = sum(x .* gamma .* Psat ./ Phi);
    if abs(P_new - P) < 1e-8 * P_new
        P = P_new;
        converged = true;
        break
    end
    P = P_new;
end
if ~converged
    error('vle:noconvergence', 'bubble_P did not converge.');
end
y = x .* gamma .* Psat ./ (Phi * P);
info = struct('gamma', gamma, 'Phi', Phi, 'iterations', iter);
end
