function P = psat(p, T_C)
%PSAT  Antoine vapour pressures (kPa) of all components at T_C (degC).
P = exp(p.antoine(:,1) - p.antoine(:,2) ./ (T_C + p.antoine(:,3)))';
end
