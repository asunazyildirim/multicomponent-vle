function p = select_components(data, ids)
%SELECT_COMPONENTS  Constants for the chosen components, in the chosen order.
%   p = SELECT_COMPONENTS(data, ids), e.g. ids = [1 2 3] for acetone/methanol/water.

p.names   = data.names(ids);
p.antoine = data.antoine(ids, :);
p.omega   = data.omega(ids);
p.Tc      = data.Tc(ids);
p.Pc      = data.Pc(ids);
p.Zc      = data.Zc(ids);
p.Vc      = data.Vc(ids);
p.a       = data.a(ids, ids);
end
