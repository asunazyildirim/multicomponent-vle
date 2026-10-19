function fugacityc=FC(n,component_number,B,P,Pisat,ylist,deltalist,T)

term1=B*(P-Pisat);
R=8.314*10^(-3);
fugacity_summation=0;
for j=[1:component_number];
    for k=[1:component_number];
        fugacity_summation= fugacity_summation + ylist(j)*ylist(k)*(2*deltalist(j,n)-deltalist(j,k));
    end
end
term2=0.5*P*fugacity_summation;
term3=R*T;
argument=(term1 + term2) / term3;
fugacityc=exp(argument);
end

