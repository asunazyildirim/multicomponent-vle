function fil=FL(component_number,Bij_list,P,Psat_list,y_list,deltaij_list,T_Kelvin)
fi_list =[];
    for i=[1:component_number];
        fi_list(i)=FC(i,component_number,Bij_list(i,i),P,Psat_list(i),y_list,deltaij_list,T_Kelvin);
    end
fil=fi_list;
end