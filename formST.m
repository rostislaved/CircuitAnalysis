function [s, t] = formST(r, c, varargin)

s = [];
t = [];
% Horizontal edges
for i = 1:c-1
   s = [s ((1:r)-1)*c+(i+0)];
   t = [t ((1:r)-1)*c+(i+1)];
end

% Verctical edges
for i = 1:r-1
   s = [s (1:c)+c*(i-1)];
   t = [t (1:c)+c*(i-0)];
end

% connect last column?
if nargin == 3
	if varargin{1} 
		for i = 1:r
		   s = [s (i-1)*c+1];
		   t = [t (i-1)*c+c];
		end
	end
end