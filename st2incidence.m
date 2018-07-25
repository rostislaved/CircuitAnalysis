function B = incidenceMine(s, t, varargin)
% Compute incidence matrix from s and t vectors
% Buildin function is not applicable because of
% inner sorting which is not possible to disable

s = s(:)';
t = t(:)';
vec = (1:max([s,t]))';

s1 = sparse(s) == vec;
t1 = sparse(t) == vec;

B = t1 - s1;
end

