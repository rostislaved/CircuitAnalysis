function [I, U, phi, rk] = MA(E, Is, R, An, C)

E = sparse(E);
Is = sparse(Is);
R = sparse(R);

    B = C;   
    r_d = diag(R);
    rk = B*r_d*B';
    E = E + R.*Is; % Transfrom current sourse in parralel branch to emf sourse in serial
    Ek = B*E;
    Ik = rk\Ek;

    I = B'*Ik; % Vector of branch current
    U = I.*R;  % Vector of branch voltage drop
    
    % Doubtful. Do we need this?
    U = U - E;
    phi = An'\U;
    
    phi = full(phi);
    I = full(I);
    U = full(U);
    
end