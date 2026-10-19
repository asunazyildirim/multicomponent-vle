function [value, comp, info] = solve_vle(calc, z, cond, p, method)
%SOLVE_VLE  Dispatch to one of the four VLE calculations.
%   [value, comp, info] = SOLVE_VLE(calc, z, cond, p, method)
%     calc    "BUBL P" | "DEW P" | "BUBL T" | "DEW T"
%     z       given composition (x for bubble, y for dew)
%     cond    T (degC) for pressure calculations, P (kPa) for temperature ones
%     method  "RL" (Raoult) | "MRL" (modified Raoult) | "GP" (gamma-phi)
%   value is P (kPa) or T (degC); comp is the composition of the other phase.

switch calc
    case "BUBL P", [value, comp, info] = bubble_P(z, cond, p, method);
    case "DEW P",  [value, comp, info] = dew_P(z, cond, p, method);
    case "BUBL T", [value, comp, info] = bubble_T(z, cond, p, method);
    case "DEW T",  [value, comp, info] = dew_T(z, cond, p, method);
    otherwise,     error('Unknown calculation "%s".', calc);
end
end
