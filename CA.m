function [Nodes, Branches] = CA( s, t, E, Is, R, varargin)
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
p = inputParse(varargin{:});


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

switch p.Method
    case 'auto'
        if nodes < indContours % Nodal Analysis
            method = 1;
            [I, U, phi, M] = NA(E, Is, R, An);
        else % Mesh Analysis
            method = 0;
            [I, U, phi, M] = MA(E, Is, R, An, C);
        end
    case 'nodal'
        method = 1;
        [I, U, phi, M] = NA(E, Is, R, An);
    case 'mesh'
            method = 0;
            [I, U, phi, M] = MA(E, Is, R, An, C);
end
    
if isequal(p.ConditionNumber, 'on')
    if method
        disp('- Nodal Analysis')
    else
        disp('- Mesh Analysis')
    end
    disp(['- Your circuit has ' num2str( size(An, 1)+1 ) ' nodes and '...
                                num2str( size(An, 2)   ) ' branches.'])
    tic
    fprintf(['- Condition number of coefficients matrix is ', numFormat( condest(M) ), '\n']);
    time = toc;   
    
    fprintf(['- Time for computing condition number is ', numFormat( time ),' seconds\n']);
end

    
if isequal(p.Coefficients, 'show') % Display g - matrix?
    if method
        % Nodal
        Gs = sym('g',[1 size(An,2)]);
        Gs = diag(Gs);
        As = sym(An);
        Gs = As*Gs*As';
    else
        % Mesh
        r_d = sym('r',[1 size(C,2)]);
        r_d = diag(r_d);
        Cs = sym(C);
        R = Cs*r_d*Cs'
    end
end



% form Nodes table
num1 = 1:length(phi)+1;
object1 = [ num1(:), [phi(:); 0] ];
Nodes = array2table(object1, 'VariableNames', {'Num';'Phi'});

% form Branches table
num2 = 1:length(s);
object2 = [num2(:), s(:), t(:), R(:), E(:), Is(:), U(:), I(:)];
Branches = array2table(object2, 'VariableNames', {'Num';'s';'t';'R';'E'; 'Is'; 'U'; 'I'});


if isequal(p.Order, '1') % Change branches order?
    EdgeTable = table([s,t], num2', 'VariableNames', {'EndNodes', 'Num'});
    g = digraph(EdgeTable);
    newOrder2 = g.Edges.Num;
    Branches = Branches(newOrder2,:);
end
