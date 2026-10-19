function Pjdew = Pjsat_dew(component_no,component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P)
P_j =Psat_list(component_no);
num=0;
for i=[1:component_number];
    m_i=mole_fraction(i);
    ac_i= Activity_Coefficient_list(i);
    Psat_i =Psat_list(i);
    fi_i = fi_list(i);
    num = num + (m_i*fi_i/ac_i)*(P_j /Psat_i);
end 
P_j = P * num ; %new
Pjdew =P_j;
end

