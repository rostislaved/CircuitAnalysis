function [A, C, varargout] = topmat(s, t)
% A - connections matrix
% C - Mesh matrix
% Q (varargout{1}) - cuts matrix

[s, t, newOrder, g, T] = stSort(s, t);

% p = plot(g);
% Labels = 1:length(s);
% labeledge(p,s,t,Labels);
% 
% highlight(p,T);


B = incidenceMine(s,t);

A = inc2nc(B);
% sz = min(size(A));
sz = size(A, 1);
A1 = A(:,1:sz);
A2 = A(:,sz+1:end);
Q2 = inv(A1)*A2;

Q = [speye(sz) Q2];
C1 = -Q2';
C = [C1 speye(length(A)-sz)];

if nargout == 3
   varargout{1} = Q;
elseif nargout == 4
   varargout{1} = Q;
   varargout{2} = newOrder;
end

end