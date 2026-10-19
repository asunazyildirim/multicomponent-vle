function gamma = wilson_gamma(x, T_C, p, method)
%WILSON_GAMMA  Liquid-phase activity coefficients from the Wilson equation.
%   gamma = WILSON_GAMMA(x, T_C, p, method); returns ones for Raoult's law.
%
%   Lambda_ij = (V_j/V_i) exp(-a_ij/RT), liquid volumes from Rackett:
%       V = Vc Zc^((1-Tr)^(2/7))
%   ln gamma_i = 1 - ln(sum_j x_j Lambda_ij) - sum_k x_k Lambda_ki / sum_j x_j Lambda_kj

if method == "RL"
    gamma = ones(size(x));
    return
end
R = 1.9872;                                   % cal/(mol K)
T = T_C + 273.15;
V = p.Vc .* p.Zc .^ ((1 - T./p.Tc) .^ (2/7));
Lambda = (V ./ V') .* exp(-p.a / (R*T));      % Lambda(i,j) = V_j/V_i exp(-a_ij/RT)

x = x(:);
S = Lambda * x;                               % S_k = sum_j x_j Lambda_kj
gamma = exp(1 - log(S) - Lambda' * (x ./ S))';
end
