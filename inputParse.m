function p = inputParse(varargin)
    p = inputParser;
    % Method
    defaultMethod = 'auto';
    validMethods = {'Auto', 'Nodal','Mesh'};
    checkMethod = @(x) any(validatestring(x,validMethods));

    % Compute condition number?
    defaultConditionNumber = 'on';
    validConditionNumber = {'on', 'off'};
    checkConditionNumber = @(x) any(validatestring(x,validConditionNumber));

    % Show coefficients?
    defaultCoefficients = 'hide';
    validCoefficients = {'show', 'hide'};
    checkCoefficients = @(x) any(validatestring(x,validCoefficients));
    
    % Branches order
    defaultOrder = '0';
    validOrder = {'0', '1'};
    checkOrder = @(x) any(validatestring(x,validOrder));


    addParameter(p,'Method',defaultMethod,checkMethod)
    addParameter(p,'ConditionNumber',defaultConditionNumber,checkConditionNumber)
    addParameter(p,'Coefficients',defaultCoefficients,checkCoefficients)
    addParameter(p,'Order',defaultOrder,checkOrder)

    parse(p,varargin{:});

    p = structfun(@lower, p.Results,'UniformOutput',false);
    
end