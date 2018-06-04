function B = incidenceMine(s, t, varargin)
% s = s(:)';
% t = t(:)';
% vec = (1:max([s,t]))';
% if nargin == 3
%     if varargin{1}
%         s1 = (vec == s);
%         t1 = (vec == t);
%     else
%         s1 = sparse(s == vec);
%         t1 = sparse(t == vec);
%     end
% else
%     s1 = sparse(s == vec);
%     t1 = sparse(t == vec);
% end
% B = t1 - s1;
% end

s = s(:)';
t = t(:)';
vec = (1:max([s,t]))';

s1 = sparse(s) == vec;
t1 = sparse(t) == vec;


B = t1 - s1;
end

