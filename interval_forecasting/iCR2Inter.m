function I = iCR2Inter (A)

for i = 1 : size(A,1)
    if (A(i,2)<0)
        A(i,2) = NaN;
    end    
end

I = [(A(:,1)-A(:,2)) (A(:,1)+A(:,2))];