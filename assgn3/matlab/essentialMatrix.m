function E = essentialMatrix(F, K1, K2)
% essentialMatrix computes the essential matrix 
%   Args:
%       F:  Fundamental Matrix
%       K1: Camera Matrix 1
%       K2: Camera Matrix 2
%
%   Returns:
%       E:  Essential Matrix
%
E = K2' * F * K1;
end