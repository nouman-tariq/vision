function T=metameric(Lf,Lg)
    error = @(T) norm((Lf - Lg)' * blackbody(T, 400:10:700));
    T = fminbnd(error, 2500, 10000);
    figure; fplot(error, [2500 10000]); xlabel('Temperature (K)'); ylabel('Euclidean Error');
end

