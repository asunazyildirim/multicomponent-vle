function P=PL(component_list,antoine,T_celcius)
Psat_list=[];
counter=1;
for i=component_list;
    A= antoine(i,1);
    B= antoine(i,2);
    C= antoine(i,3);
    Psat_calculated= Psat(A,B,C,T_celcius);
    Psat_list(counter)=Psat_calculated;
    counter= counter +1;
end
P= Psat_list;
end