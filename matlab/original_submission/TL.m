function t=TL(component_list,antoine,P)
Tsatdegree_list=[];
counter=1;
for i=component_list;
    A= antoine(i,1);
    B= antoine(i,2);
    C= antoine(i,3);
    Tsatdegree_calculated= Tsat(A,B,C,P);
    Tsatdegree_list(counter)=Tsatdegree_calculated;
    counter= counter +1;
end
t=Tsatdegree_list;
end