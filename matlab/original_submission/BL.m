function B=BL(component_list,others,T_Kelvin)

Bij_list=[];
row_counter=1;
for row=component_list;
    column_counter=1;
    for column=component_list;
        wi=others(row,1);
        wj=others(column,1);
        w_ij = wij(wi,wj);

        Tci=others(row,2);
        Tcj=others(column,2);
        Tc_ij = Tcij(Tci,Tcj);

        Zi=others(row,4);
        Zj=others(column,4);
        Z_ij = Zij(Zi,Zj);

        Vci=others(row,5);
        Vcj=others(column,5);
        Vc_ij = Vcij(Vci,Vcj);

        Pc_ij = Pcij(Z_ij,Tc_ij,Vc_ij);

        Bij_list(row_counter,column_counter) = Bij(Pc_ij,Tc_ij,w_ij, T_Kelvin);

        column_counter = column_counter +1;
    end
    row_counter= row_counter + 1;
end
B=Bij_list;
end