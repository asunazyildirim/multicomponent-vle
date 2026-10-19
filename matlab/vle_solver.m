% VLE_SOLVER  Interactive n-component vapour-liquid equilibrium calculator.
%
%   Calculations: bubble P, dew P, bubble T, dew T
%   Methods:      Raoult's law (RL), modified Raoult's law (MRL),
%                 gamma-phi (Wilson activity + virial fugacity coefficients)
%   Components and constants are read from ../data; add a row (and a
%   Wilson row/column) there to make a new component available.

clc;
root = fullfile(fileparts(mfilename('fullpath')), '..');
data = load_vle_data(fullfile(root, 'data'));
nAll = numel(data.names);

calcs   = ["BUBL P" "DEW P" "BUBL T" "DEW T"];
methods = ["RL" "MRL" "GP"];
calc   = calcs(ask_choice("Calculation", ["Bubble pressure" "Dew pressure" "Bubble temperature" "Dew temperature"]));
method = methods(ask_choice("Formulation", ["Raoult's law" "Modified Raoult's law" "Gamma-phi"]));

% --- Components and composition ----------------------------------------
if startsWith(calc, "BUBL"), given = "x"; other = "y"; else, given = "y"; other = "x"; end
while true
    n = ask_number(sprintf('Number of components (1-%d): ', nAll));
    if n >= 1 && n <= nAll && n == fix(n), break; end
    fprintf('Please enter an integer between 1 and %d.\n', nAll);
end
fprintf('\n'); print_menu(data.names); fprintf('\n');
while true
    ids = zeros(1, n); z = zeros(1, n);
    for i = 1:n
        ids(i) = ask_number(sprintf('Component %d (number from the list): ', i));
        z(i)   = ask_number(sprintf('  its mole fraction %s%d: ', given, i));
    end
    if any(~ismember(ids, 1:nAll))
        fprintf('Component numbers must be between 1 and %d.\n', nAll);
    elseif numel(unique(ids)) < n
        fprintf('Each component can only be entered once.\n');
    elseif any(z <= 0)
        fprintf('Mole fractions must be positive.\n');
    elseif abs(sum(z) - 1) > 1e-6        % tolerance: 0.1+0.2+0.7 is not exactly 1 in floating point
        fprintf('Mole fractions add up to %.4g, not 1. Please re-enter.\n', sum(z));
    else
        break
    end
end

% --- Temperature or pressure ---------------------------------------------
while true
    if endsWith(calc, "P")
        cond = ask_number('Temperature (degC): ');
        if cond > -273.15, break; end
        fprintf('Temperature must be above absolute zero.\n');
    else
        cond = ask_number('Pressure (kPa): ');
        if cond > 0, break; end
        fprintf('Pressure must be positive.\n');
    end
end

% --- Solve and report ------------------------------------------------------
p = select_components(data, ids);
try
    [value, comp, info] = solve_vle(calc, z, cond, p, method);
catch err
    fprintf(2, '\n%s\n', err.message);
    return
end
if endsWith(calc, "P")
    fprintf('\n%s (%s) at T = %g degC:  P = %.4f kPa\n\n', calc, method, cond, value);
else
    fprintf('\n%s (%s) at P = %g kPa:  T = %.4f degC\n\n', calc, method, cond, value);
end
disp(table(p.names', z', comp', info.gamma', info.Phi', ...
     'VariableNames', {'component', char(given), char(other), 'gamma', 'Phi'}))

function k = ask_choice(label, options)
% Show a numbered menu and return a valid choice.
fprintf('%s:\n', label);
print_menu(options);
while true
    k = ask_number('Choice: ');
    if ismember(k, 1:numel(options)), fprintf('\n'); return; end
    fprintf('Please enter a number between 1 and %d.\n', numel(options));
end
end

function print_menu(options)
for k = 1:numel(options)
    fprintf('  %d => %s\n', k, options(k));
end
end

function v = ask_number(prompt)
% Ask until the user types a single real number.
while true
    v = input(prompt);
    if isscalar(v) && isnumeric(v) && isreal(v) && isfinite(v), return; end
    fprintf('Please enter a single number.\n');
end
end
