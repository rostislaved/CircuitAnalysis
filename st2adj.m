function adj = st2adj(s, t)
% Converts s and t vectors to adjacency matrix
% Algorithm is not the most efficient, but shurely correct

adj =adjacency(graph(s,t));

end

