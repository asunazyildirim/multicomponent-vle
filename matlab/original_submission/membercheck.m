function uy=membercheck(component_number,component_list)
uye=0;
for i=[1:component_number];
    if ismember(component_list(i),[1,2,3,4,5]) ==0
        uye=1;
    end
end
uy=uye;
end
   