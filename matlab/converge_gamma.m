function gamma = converge_gamma(y, Phi, P, Psat, gamma, T_C, p, method)
%CONVERGE_GAMMA  Inner loop of the dew-point algorithms.
%   Repeats x = y Phi P / (gamma Psat), normalize x, gamma = gamma(x)
%   until the activity coefficients stop changing.

for k = 1:500
    x = y .* Phi * P ./ (gamma .* Psat);
    x = x / sum(x);
    gamma_new = wilson_gamma(x, T_C, p, method);
    if max(abs(gamma_new - gamma)) < 1e-10
        gamma = gamma_new;
        return
    end
    gamma = gamma_new;
end
error('vle:noconvergence', 'Activity-coefficient loop did not converge.');
end
