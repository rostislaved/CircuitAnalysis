A = st2adj(s,t);
mainG = graph(A~=0);
a = table2array(mainG.Edges);
s = a(:,1)';
t = a(:,2)';

G = digraph(s,t);
str = ["force","force3","subspace","subspace3","layered"];
str = str(1);
p = plot(mainG,'layout',str);
% p = plot(mainG,'layout',str,'EdgeLabel',1:height(G.Edges));


A = st2adj(s,t);
mainG = graph(A~=0);
% return
% move graph to center
x = p.XData;
y = p.YData;
x_center = sum(xlim)/2;
y_center = sum(ylim)/2;
x = x - x_center;
y = y - y_center;
p.XData = x*2;
p.YData = y;
% return
% rotate graph
angle = 45;
x = p.XData;
y = p.YData;
p = plot(x,y);
rotate( p, [0 0 1], angle);
% rotate( p, [0 1 0], 180);
x2 = p.XData;
y2 = p.YData;
p = plot(mainG,'layout',str);
p = plot(mainG,'layout',str,'EdgeLabel',1:height(G.Edges)) ;
p.XData = x2;
p.YData = y2;
