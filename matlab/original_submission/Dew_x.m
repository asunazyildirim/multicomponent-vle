function dew=Dew_x(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P)
x_list =[];
for i=[1:component_number];
    m_i=mole_fraction(i);
    ac_i= Activity_Coefficient_list(i);
    Psat_i =Psat_list(i);
    fi_i = fi_list(i);
    x_list(i)= (m_i*fi_i*P)/(ac_i*Psat_i);
end
dew=x_list;
end