function [Nodes, BranchesTable] = CircuitAnalysis( s, t, E, Is, R, varargin)
% ========================================================================
% Circuit analysis function
% ========================================================================
% Inputs:
% 1. s  - Vector of start nodes
% 2. t  - Vector of target nodes
% 3. E  - Vector of branch emf
% 4. Is - Vector of branch current (in parralel)
% 5. R  - Vector of branch resistance
% 6 .varargin - name - value pair
%   6.1 Method of solving
%       Name: 'Method'
%       Value: 'Auto' (Default) | 'Nodal' | 'Mesh"
%   6.2 Disable computation of condition number because it can take much time
%       Name: 'ConditionNumber'
%       Value: 'on' (default) | 'off'
%   6.3 Order of branches in Branches table (applies only for mesh method)
%       Name: 'Order'
%       Value: 'Branches' (Defalut) | 'Nodes' | 'mst' |
%       'Branches' - order as was set in s and t vectors
%       'Nodes' - ascending order of nodes (sorted by algorithm built in a 'graph' functuion)
%       'mst' - order as was sorted by convention for forming Mesh matrix
%   6.4 Display matrix of coefficients in a symbolic way
%       Name: 'Coefficients'
%       Value: 'Hide' (Defalut) | 'Show'
% ========================================================================
% Outputs:
% 1. Nodes - Table with all information about nodes:
%   1.1 Num - Number of node
%   1.2 Phi - Node potential
% 2. Branches -  Table with all information about branches:
%   2.1 Num - Number of the branch
%   2.2 s - number of start node for branch Num
%   2.3 t - number of target node for branch Num
%   2.4 R - Branch resistance
%   2.5 E - Branch EMF
%   2.6 Is - Branch current (in parralel)
%   2.7 U - Branch voltage drop
%   2.8 I - Branch current (from node s to node t)
% ========================================================================

%% Prepare inputs ========================================================
p = inputParse(varargin{:}); % Parse Name-value pair of arguments

s  = s(:);
t  = t(:);
E  = E(:);
Is = Is(:);
R  = R(:);
% ========================================================================

%% =======================================================================
% Compute topological matrices of circuit and change order of
% branches: branches of tree first and branches of connections next
[An, C, ~, newOrder] = topmat(s, t);

s  = s(newOrder);
t  = t(newOrder);
E  = E(newOrder);
Is = Is(newOrder);
R  = R(newOrder);

branchesNumbers = (1:length(s))';
branchesNumbers = branchesNumbers(newOrder);
% ========================================================================

%% Choose solving method =================================================
nodesMo     = size(An, 1); % Number of nodes minus one
indContours = size(C , 1); % Number of independent contours
switch p.Method
    case 'auto'
        if nodesMo < indContours % Nodal Analysis
            method = 1;
        else % Mesh Analysis
            method = 0;
        end
    case 'nodal'
        method = 1;
    case 'mesh'
        method = 0;
end
% ========================================================================

%% Computation by chosen method ==========================================
if method
    [I, U, phi, M] = NA(E, Is, R, An);
else
    [I, U, phi, M] = MA(E, Is, R, An, C);
end
% ========================================================================

%% Printing info =========================================================
if method
    disp('- Nodal Analysis')
else
    disp('- Mesh Analysis')
end
disp(['- Your circuit has ' num2str( size(An, 1)+1 ) ' nodes and '...
                            num2str( size(An, 2)   ) ' branches.'])

if isequal(p.ConditionNumber, 'on')
    tic
    fprintf(['- Condition number of coefficients matrix is ', numFormat( condest(M) ), '\n']);
    time = toc;
    fprintf(['- Time for computing condition number is ', numFormat( time ),' seconds\n']);
    % Rcond ================
    % 0 - badly conditioned
    % 1 - ill conditioned
    % Cond(est)=============
    % 0 - well  conditioned
    % 1e16 - ill conditioned
    % ======================
end
 
if isequal(p.Coefficients, 'show') % Display g - matrix?
    if method
        % Nodal
        Gs = sym('g',[1 size(An,2)]);
        Gs = diag(Gs);
        As = sym(An);
        Gss = As*Gs*As'
    else
        % Mesh
        r_d = sym('r',[1 size(C,2)]);
        r_d = diag(r_d);
        Cs = sym(C);
        Rs = Cs*r_d*Cs'
    end
end
% ========================================================================

%% Form output ===========================================================
% Sort nodes
num1 = 1:length(phi)+1;
object1 = [ num1(:), [phi(:); 0] ];

% Form nodes table
Nodes = array2table(object1, 'VariableNames', {'Num';'Potential'});

% Sort branches
Branches =  [branchesNumbers(:), s(:), t(:), R(:), E(:), Is(:), U(:), I(:)];
switch p.Order
    case 'branches'
        [~, finalOrder] = sort(branchesNumbers);
    case 'nodes'
        EdgeTable = table([s,t], branchesNumbers, 'VariableNames', {'EndNodes', 'Branch'});
        tempG = digraph(EdgeTable);
        [~, finalOrder] = ismember(tempG.Edges.Branch, branchesNumbers);
    case 'mst'
        finalOrder = branchesNumbers;
end
Branches = Branches(finalOrder,:);

% Form branches table
BranchesTable = array2table(Branches, 'VariableNames', {'Branch';'s';'t';'R';'E'; 'J'; 'U'; 'I'});
% ========================================================================