function inc = st2inc(s, t)
% Converts s and t vectors to incidence matrix
% Algorithm is not the most efficient, but shurely correct

inc = incidence(graph(s,t));

end

