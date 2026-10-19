function D=DL(component_number,Bij_list)
deltaij_list =[];
for i=[1:component_number];
    for j=[1:component_number];
        deltaij_list(i,j)=2*Bij_list(i,j)-Bij_list(i,i)-Bij_list(j,j);
    end
end
D=deltaij_list;
end