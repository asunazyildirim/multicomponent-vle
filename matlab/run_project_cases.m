% RUN_PROJECT_CASES  All conditions of the term project, non-interactively.
%
%   3 systems x 4 calculations x 5 conditions x 3 methods = 180 runs.
%   Results are written to ../results/project_cases.csv and the phase
%   envelopes (bubble and dew pressure vs temperature) are plotted.

clc; clear; close all;
root = fullfile(fileparts(mfilename('fullpath')), '..');
data = load_vle_data(fullfile(root, 'data'));

systems = {'System 1', [1 2 3]      % acetone / methanol / water
           'System 2', [4 5 3]      % methyl acetate / benzene / water
           'System 3', [1 2 5]};    % acetone / methanol / benzene
calcs   = ["BUBL P" "DEW P" "BUBL T" "DEW T"];
methods = ["RL" "MRL" "GP"];

% Table 1 of the assignment: three T (or P) levels at the base composition,
% plus two more compositions at the lowest T (or P).
base  = [0.3 0.4 0.3];
comps = {base, [0.4 0.4 0.2], [0.5 0.4 0.1]};
T_levels = [70 80 90];          % degC, for pressure calculations
P_levels = [150 300 450];       % kPa, for temperature calculations

rows = {};
for s = 1:size(systems, 1)
    p = select_components(data, systems{s,2});
    for calc = calcs
        if endsWith(calc, "P"), levels = T_levels; else, levels = P_levels; end
        conds = [num2cell(levels(:)), repmat({base}, 3, 1)
                 {levels(1), comps{2}; levels(1), comps{3}}];
        for c = 1:size(conds, 1)
            [cond, z] = conds{c,:};
            for m = methods
                [value, comp] = solve_vle(calc, z, cond, p, m);
                rows(end+1, :) = {systems{s,1}, calc, m, cond, z(1), z(2), z(3), ...
                                  value, comp(1), comp(2), comp(3)}; %#ok<SAGROW>
            end
        end
    end
end
results = cell2table(rows, 'VariableNames', {'system', 'calculation', 'method', ...
    'T_or_P_given', 'z1', 'z2', 'z3', 'result', 'w1', 'w2', 'w3'});
% result: P (kPa) for BUBL P / DEW P, T (degC) for BUBL T / DEW T
% w1..w3: composition of the other phase (y for bubble, x for dew)
writetable(results, fullfile(root, 'results', 'project_cases.csv'));
disp(results(results.z1 == 0.3 & ismember(results.T_or_P_given, [70 150]), :))

% --- Phase envelopes: bubble and dew pressure vs temperature ---------------
fig = figure('Color', 'w', 'Position', [100 100 1250 400]);
tiledlayout(1, 3, 'TileSpacing', 'compact');
T = linspace(40, 120, 41);
colors = lines(3);
for s = 1:size(systems, 1)
    p = select_components(data, systems{s,2});
    nexttile; hold on;
    for k = 1:numel(methods)
        Pb = arrayfun(@(t) bubble_P(base, t, p, methods(k)), T);
        Pd = arrayfun(@(t) dew_P(base, t, p, methods(k)), T);
        plot(T, Pb, '-',  'Color', colors(k,:), 'LineWidth', 1.6, 'DisplayName', methods(k) + " bubble");
        plot(T, Pd, '--', 'Color', colors(k,:), 'LineWidth', 1.6, 'DisplayName', methods(k) + " dew");
    end
    title(sprintf('%s: %s', systems{s,1}, strjoin(p.names, ' / ')), 'FontWeight', 'normal');
    xlabel('Temperature (\circC)'); ylabel('Pressure (kPa)'); grid on;
    if s == 1, legend('Location', 'northwest', 'NumColumns', 1); end
end
set(findall(fig, 'Type', 'axes'), 'Toolbar', []);
exportgraphics(fig, fullfile(root, 'figures', 'phase_envelopes.png'), 'Resolution', 150);
