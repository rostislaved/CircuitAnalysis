function [ phi, I, varargout ] = NPM2( E, r, An )
% Returns:
% 1. u - nodes' potentials
% 2. I - branches' currents
% 3. (optional) Branch voltage drop
% Rcond ================
% 0 - badly conditioned
% 1 - ill conditioned
% Cond(est)=============
% 0 - well  conditioned
% 1e16 - ill conditioned
% ======================

E = E(:);
r = r(:);

if ( issparse(E) ||...
     issparse(r) ||...
     issparse(An) )

    sparseAlg = 1;

    E  = sparse(E);
    r  = sparse(r);
    An = sparse(An);

    g  = sparse(1./r);
else
    sparseAlg = 0;

    nml = numel(An);
    sparsity = 1 - nnz(An)/nml;  
    if (sparsity > 0.5 && nml > 1e3)
        fprintf('- Your matrix has %2.1f sparcity for %d elements. Try to use sparse matrices\n',sparsity, nml);
    end

    g = 1./r;
end

    g_d = diag(g);
    G = An*g_d*An'; % Matrix of coefficients

    J = -sum((E.*g)'.*An,2); % Right part of the system
    phi = G\J;   % Potentials from 1st to  n-1 nodes
    U = An'*phi; % Potendials without taking sources into account
    U = (U + E); % Potendials with taking sources into account
    I = U.*g;   % Currents
    
if sparseAlg % convert back to full because these vectors always have sparsity 0
    phi = full(phi);
    I = full(I);
    U = full(U);
end
    
if 1
    [rows,columns] = size(An);
    disp(['- It is implied by [An] matrix that your circuit has to have ' num2str(rows+1) ' nodes and ' num2str(columns) ' branches.'])

    if sparseAlg
        disp('- Using sparse algorithm')
        disp(['- Condition number of coefficients matrix = ',sprintf('%1.1e',condest(G))]);
    else
        disp('- Using not sparse algorithm')
        disp(['- Condition number of coefficients matrix = ',sprintf('%1.1e',cond(G))]);
    end
end
    
    
if 0 % Display g - matrix?
    Gs = sym('g',[1 size(An,2)]);
    Gs = diag(Gs);
    As = sym(An);
    Gs = As*Gs*As'
end


if ~all(all(tril(G,-1)'==triu(G,1)))
    error('Incidence matrix constructed wrong');
    % In other words, mutual admittances are not equal, that is wrong
end
if nargout == 3
    varargout{1} = U;
end

end

