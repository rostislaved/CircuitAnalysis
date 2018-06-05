function [s,t] = rmCorners(s,t, r,c)
    grph = graph(s,t);
    s2 = [2 c-1 (r-2)*c+1 (r-1)*c];
    t2 = [c+1 2*c (r-1)*c+2 r*c-1];
    grph = addedge(grph,s2,t2);
    grph = rmnode(grph,[1 c (r-1)*c+1 r*c]);
    [s, t] = graph2st(grph);
end