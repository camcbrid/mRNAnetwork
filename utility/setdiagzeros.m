function Aout = setdiagzeros(A)

Aout = A;
for ii = 1:min(size(A))
    Aout(ii,ii) = 0;
end
