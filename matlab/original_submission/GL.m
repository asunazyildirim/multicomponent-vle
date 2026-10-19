function G=GL(T_Kelvin,wilson,others,component_list)
Volume_list=[];
counter=1;
for i=component_list;
    Tc= others(i,2);
    Vc= others(i,5);
    Zc= others(i,4);
    Volume_calculated = Volume(Vc,Zc,T_Kelvin,Tc);
    Volume_list(counter)=Volume_calculated;
    counter= counter +1;
end
Gama_list=[];
row_counter=1;
for row=component_list;
    column_counter=1;
    for column=component_list;
        Vi = Volume_list(row_counter);
        Vj = Volume_list(column_counter);
        aij= wilson(row,column);
        Gama_list(row_counter,column_counter)= Gama(Vi,Vj,aij,T_Kelvin);
        column_counter = column_counter +1;
    end
    row_counter= row_counter + 1;
end
G=Gama_list;
end
