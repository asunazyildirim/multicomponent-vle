function [T_C, y, info] = bubble_T(x, P, p, method)
%BUBBLE_T  Bubble-point temperature (degC) and vapour composition at P (kPa).
%   [T_C, y, info] = BUBBLE_T(x, P, p, method), method = "RL" | "MRL" | "GP".
%
%   Smith, Van Ness & Abbott BUBL T algorithm: pick component j (here 1),
%   Psat_j = P / sum_i (x_i gamma_i / Phi_i)(Psat_i / Psat_j),
%   T = Tsat_j(Psat_j), and repeat until T converges.

j   = 1;
Phi = ones(size(x));
T_C = sum(x .* tsat(p, P));                   % initial guess

converged = false;
for iter = 1:500
    Psat   = psat(p, T_C);
    gamma  = wilson_gamma(x, T_C, p, method);
    Psat_j = P / sum(x .* gamma ./ Phi .* Psat / Psat(j));
    T_new  = tsat(p, Psat_j, j);
    Psat   = psat(p, T_new);
    y      = x .* gamma .* Psat ./ (Phi * P);
    Phi    = virial_phi(y, P, T_new, Psat, p, method);
    if abs(T_new - T_C) < 1e-8
        T_C = T_new;
        converged = true;
        break
    end
    T_C = T_new;
end
if ~converged
    error('vle:noconvergence', 'bubble_T did not converge.');
end
gamma = wilson_gamma(x, T_C, p, method);
Psat  = psat(p, T_C);
y     = x .* gamma .* Psat ./ (Phi * P);
info  = struct('gamma', gamma, 'Phi', Phi, 'iterations', iter);
end
