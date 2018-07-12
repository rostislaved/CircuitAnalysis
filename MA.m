function [I, U, phi, rk] = MA(E, J, R, An, C)

E = sparse(E);
J = sparse(J);
R = sparse(R);

    r_d = diag(R);   
    
    rk = C*r_d*C';  % Matrix of coefficients
    Ek = C*(E - R.*J);   % Right part of the system (Voltages)
    Ik = rk\Ek; % Solve system of linear equations

    I = (Ik'*C)' + J; % Vector of branch current

    U = I.*R - E; % Vector of branch voltage drop
    phi  = An'\U;

    
    
    
    
phi = full(phi);
I = full(I);
U = full(U);
    
end