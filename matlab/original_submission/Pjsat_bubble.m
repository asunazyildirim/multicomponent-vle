function pj=Pjsat_bubble(component_no,component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P)
P_j =Psat_list(component_no);
denum=0;
for i=[1:component_number];
    m_i=mole_fraction(i);
    ac_i= Activity_Coefficient_list(i);
    Psat_i =Psat_list(i);
    fi_i = fi_list(i);
    denum = denum + (m_i*ac_i/fi_i)*(Psat_i /P_j);
end 
P_j = P / denum; %new
pj=P_j;
end
