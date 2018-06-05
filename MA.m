function [Nodes, Branches] = MA( s, t, E, Is, R, varargin)
% ========================================================================
% Mesh analysis function
% ========================================================================
% % % % % % Inputs:
% % % % % % 1. s  - Vector of start nodes
% % % % % % 2. t  - Vector of target nodes
% % % % % % 3. E  - Vector of branch emf
% % % % % % 4. Is - Vector of branch current (in parralel)
% % % % % % 5. R  - Vector of branch resistance
% % % % % % 6 .varargin{1} - order of output branches
% % % % % %   0 (default) | 1
% % % % % %   0 - order as in vectors s and t
% % % % % % 	1 - order as if s and t were sorted by built-in sort in graph function
% % % % % % ========================================================================
% % % % % % Outputs:
% % % % % % 1. Nodes - Table with all information about nodes:
% % % % % %   1.1 Num - Number of node
% % % % % %   1.2 Phi - Node potential
% % % % % % 2. Branches -  Table with all information about branches:
% % % % % %   2.1 Num - Number of branch
% % % % % %   2.2 s - number of start node for branch Num
% % % % % %   2.3 t - number of target node for branch Num
% % % % % %   2.4 R - Branch resistance
% % % % % %   2.5 E - Branch EMF
% % % % % %   2.6 Is - Branch current (in parralel)
% % % % % %   2.7 U - Branch voltage drop
% % % % % %   2.8 I - Branch current (from node s to node t)
% % % % % % ========================================================================

% Rcond ================
% 0 - badly conditioned
% 1 - ill conditioned
% Cond(est)=============
% 0 - well  conditioned
% 1e16 - ill conditioned
% ======================

E = sparse(E);
Is = sparse(Is);
R = sparse(R);

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

[nodes ~] = size(An); % Number of nodes minus one
[indContours ~] = size(C); % Number of independent contours

if nodes < indContours
    disp('Nodal analysis')    
else
    disp('Mesh analysis')
end



% =================================================
B = C;

    r_d = diag(R);
    rk = B*r_d*B';
    E = E + R.*Is; % Transfrom current sourse in parralel branch to emf sourse in serial
    Ek = B*E;
    Ik = rk\Ek;

    I = B'*Ik; % Vector of branch current
    U = I.*R ; % Vector of branch voltage drop
    
    % Doubtful. Do we need this?
    U = U - E;
    phi = An'\U ;
    


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
    cnd = condest(rk);
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