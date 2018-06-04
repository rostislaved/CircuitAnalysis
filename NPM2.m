function [Nodes, Branches] = NPM2( s, t, E, Is, R, varargin)
% Inputs:
% s  - Vector of starting nodes
% t  - Vector of target nodes
% E  - Vector of branch emf
% Is - Vector of branch current (in parralel)
% R  - Vector of branch resistance
%
%
%
%

% Rcond ================
% 0 - badly conditioned
% 1 - ill conditioned
% Cond(est)=============
% 0 - well  conditioned
% 1e16 - ill conditioned
% ======================

E = sparse(E);
Is = sparse(Is);


s  = s(:);
t  = t(:);
E  = E(:);
Is = Is(:);
R  = R(:);
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++

[An, C, Q, newOrder] = topmat(s, t);

s = s(newOrder);
t = t(newOrder);
E = E(newOrder);
Is = Is(newOrder);
R = R(newOrder);
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++
% =================================================

    
    
    g  = sparse(1)./R;
    g_d = diag(g);
    G = An*g_d*An'; % Matrix of coefficients
    E = E + R.*Is; % Transfrom current sourse in parralel branch to emf sourse in serial
    J = -sum((E.*g)'.*An,2); % Right part of the system
    phi = G\J;   % Potentials from 1st to  n-1 nodes
    U = An'*phi; % Potendials without taking sources into account
    U = (U + E); % Potendials with taking sources into account
    I = U.*g;    % Currents

if 1 % convert back to full because these vectors always have sparsity 0
    phi = full(phi);
    I = full(I);
    U = full(U);
    Is = full(Is);
end

if 0
    [rows,columns] = size(An);
    disp(['- It is implied by [An] matrix that your circuit has to have ' num2str(rows+1) ' nodes and ' num2str(columns) ' branches.'])
    tic
    cnd = condest(G);
    time = toc;
    if cnd > 1000 | cnd < 0.1
        str = '%1.1e\n';
    else
        str = '%1.1f\n';
    end
    fprintf(['- Condition number of coefficients matrix is ',str], cnd);
    fprintf('- Time for computing condition number is %1.2e seconds\n', time);
end

    
if 0 % Display g - matrix?
    Gs = sym('g',[1 size(An,2)]);
    Gs = diag(Gs);
    As = sym(An);
    Gs = As*Gs*As'
end


% if ~all(all(tril(G,-1)'==triu(G,1)))
%     error('Incidence matrix constructed wrong');
%     % In other words, mutual admittances are not equal, that is wrong
% end

num1 = 1:length(phi)+1;

object1 = [ num1(:), [phi(:); 0] ];
Nodes = array2table(object1, 'VariableNames', {'Num';'Phi'});
oo = ( 1:length(s) )';

EdgeTable = table([s,t],oo,'VariableNames',{'EndNodes','Num'});



num2 = 1:length(s);
object2 = [num2(:), s(:), t(:), R(:), E(:), Is(:), U(:), I(:)];
Branches = array2table(object2, 'VariableNames', {'Num';'s';'t';'R';'E'; 'Is'; 'U'; 'I'});

if nargin == 6
    if varargin{1}
    g = digraph(EdgeTable);
    newOrder2 = g.Edges.Num;
    Branches = Branches(newOrder2,:);
    end
end