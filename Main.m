clear
fullScr = struct('units','normalized','outerposition',[0 0.017 1 0.983]);
% close all
% clf
clc

input = 2;

if input == 1
    % Inputs 1
    s = [5 2 3 4 2 3 6 6 6];
    t = [1 1 1 3 4 5 4 5 2];
    E = [19 28 19 38 24 20 27 11 16];
    R = [33 37 6 37 26 4 12 22 39];
    Is = rand (size(E));
    Is = zeros(size(E));
elseif input == 2
    % Inputs 2
    s = [1 2 2 3 1];
    t = [3 1 3 1 2];
    E = [60 80 70 0 0];
    R = [20 50 5 65 85];
    Is = rand (size(E));
elseif input == 3
    % Inputs 3
    rng(1)
    s = randi([1 1000], 1, 9e4);
    t = randi([1 1000], 1, 9e4);

    E = randi([1 100], 1, length(s));
    R = randi([1 100], 1, length(s));
    Is = zeros(size(E));
end




[Nodes, Branches] = CircuitAnalysis( s, t, E, Is, R,'ConditionNumber','off','Method','auto','order','0')
