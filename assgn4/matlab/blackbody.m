function L=blackbody(T, lambdas)
% Generates a discretized illuminant spectrum under blackbody.
% T in K
% lambdas in nm
lambdas = lambdas * 10^(-9);
a = 1.4388 * 10^(-2);
[~, N] = size(lambdas);
L = zeros(N, 1);
for i=1:N
   lambda = lambdas(i);
   L(i) = 1/(lambda^5 * (exp(a/(lambda*T)) - 1));
end
L = L / sum(L);
end