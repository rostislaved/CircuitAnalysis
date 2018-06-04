function [s, t] = stDelDuplicates(s,t)
% Delete duplicates from s and t vectors
% Example:
% clear
% clc
% 
% rng(1);
% s = randi([1 10000],1,4e4);
% t = randi([1 10000],1,4e4);
% 
% size(s)
% [s, t] = stDelDuplicates(s,t);
% size(s)

sz = size(s);
if sz(2) > 2
    tg = 1;
else
    tg = 0;
end
    g = graph(s,t,'OmitSelfLoops');
    a = adjacency(g);
    g = graph(a~=0);
    a = table2array(g.Edges);
    s = a(:,1);
    t = a(:,2);
    if tg
        s = s';
        t = t';
    end
        