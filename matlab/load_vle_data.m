function data = load_vle_data(dataDir)
%LOAD_VLE_DATA  Read pure-component constants and Wilson parameters.
%   data = LOAD_VLE_DATA(dataDir) reads components.csv and wilson_aij.csv.
%   Any number of components can be added to the files; nothing in the
%   code depends on how many there are.
%
%   data.names    component names (string array)
%   data.antoine  [A B C]: ln(Psat/kPa) = A - B/(t/degC + C)
%   data.omega, data.Tc (K), data.Pc (bar), data.Zc, data.Vc (cm^3/mol)
%   data.a        Wilson energy parameters a_ij (cal/mol)

C = readtable(fullfile(dataDir, 'components.csv'), 'TextType', 'string');
data.names   = C.name';
data.antoine = [C.antoine_A C.antoine_B C.antoine_C];
data.omega   = C.omega';
data.Tc      = C.Tc_K';
data.Pc      = C.Pc_bar';
data.Zc      = C.Zc';
data.Vc      = C.Vc_cm3_per_mol';

W = readmatrix(fullfile(dataDir, 'wilson_aij.csv'), 'Range', [2 2]);
if ~isequal(size(W), [numel(data.names) numel(data.names)])
    error('wilson_aij.csv must be an n-by-n matrix matching components.csv.');
end
data.a = W;
end
