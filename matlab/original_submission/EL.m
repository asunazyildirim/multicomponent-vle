function el=EL(component_number,Activity_Coefficient_list,Activity_Coefficient_list_new)
error_list=ones(1,component_number);
for i=[1:component_number];
    if abs(Activity_Coefficient_list(i)-Activity_Coefficient_list_new(i)) <= 10^-4;
        error_list(i)=0;
    end
end
el=error_list;
end

