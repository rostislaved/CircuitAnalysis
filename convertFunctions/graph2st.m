function [s, t] = graph2st(g)
	T = table2array(g.Edges);
	s = T(:,1);
	t = T(:,2);
end