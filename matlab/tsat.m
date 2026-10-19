function T_C = tsat(p, P_kPa, i)
%TSAT  Antoine saturation temperature (degC) at P_kPa.
%   TSAT(p, P) returns all components; TSAT(p, P, i) only component i.
if nargin < 3, i = 1:size(p.antoine, 1); end
A = p.antoine(i,1); B = p.antoine(i,2); C = p.antoine(i,3);
T_C = (B ./ (A - log(P_kPa)) - C)';
end
