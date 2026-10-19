function Bub=Bubble_P(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list)
P=0;
for i=[1:component_number];
    m_i=mole_fraction(i);
    ac_i= Activity_Coefficient_list(i);
    Psat_i =Psat_list(i);
    fi_i = fi_list(i);
    P = P + (m_i*ac_i*Psat_i)/fi_i ;
end
Bub=P;
end