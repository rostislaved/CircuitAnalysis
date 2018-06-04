function [s, t, varargout] = stSort(s, t)
% Do not use with (di)graph functions! Order will be lost!
s = s(:);
t = t(:);

oldOrder = (1:length(s))';
EdgeTable = table([s t], oldOrder, 'VariableNames', {'EndNodes' 'Num'});
G = graph(EdgeTable);

mstG = minspantree(G);

newOrder1 = sort(mstG.Edges.Num);
newOrder2 = setdiff(oldOrder,newOrder1);
newOrder  = [newOrder1; newOrder2];
T  = EdgeTable{newOrder,1};
s = T(:,1);
t = T(:,2);
Tr  = EdgeTable(newOrder1,1);
Con = EdgeTable(newOrder2,1);

if nargout == 3
    varargout{1} = newOrder;
elseif nargout == 5
    G = digraph([Tr; Con]); % Full digraph
    T = digraph(Tr); % Digraph of minspantree
    
    varargout{1} = newOrder;
    varargout{2} = G;
    varargout{3} = T;
end

end

