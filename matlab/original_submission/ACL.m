function Acc_li=ACL(component_number,mole_fraction,Gama_list)
Activity_Coefficient_list = [];
for i=[1:component_number];
    Activity_Coefficient_list(i)= AC(i,component_number,mole_fraction,Gama_list);
end
Acc_li=Activity_Coefficient_list;

end